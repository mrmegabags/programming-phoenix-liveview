defmodule PentoWeb.WrongLiveTest do
  use PentoWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  @route "/guess"

  test "initial render shows score, message, time, and guess buttons", %{conn: conn} do
    {:ok, view, html} = live(conn, @route)

    assert html =~ "Your score:"
    assert html =~ "Make a guess:"
    # sanity check: one of the buttons is present
    assert has_element?(view, ~s|a[phx-click="guess"]|, "1")
    assert has_element?(view, ~s|a[phx-click="guess"]|, "10")

    # No restart link initially
    refute has_element?(view, "a", "Play again")
  end

  test "clicking guesses updates UI (no full reload) and eventually wins", %{conn: conn} do
    {:ok, view, _html} = live(conn, @route)

    # Score starts at 0
    assert score_from(render(view)) == 0

    # Click 1..10 until we win. While we have not won, each wrong guess decrements score by 1.
    wrongs =
      Enum.reduce_while(1..10, 0, fn n, wrong_count ->
        html = render_click(element(view, "a", Integer.to_string(n)))

        if html =~ "You Won!" do
          # On win: won UI should be present, guess buttons should be hidden
          assert has_element?(view, "a", "Play again")
          refute has_element?(view, ~s|a[phx-click="guess"]|, "1")
          {:halt, wrong_count}
        else
          # Still playing: score should equal -(number of wrong guesses so far)
          wrong_count = wrong_count + 1
          assert score_from(html) == -wrong_count
          {:cont, wrong_count}
        end
      end)

    # We must win within 10 clicks because answer is in 1..10 and does not change mid-game
    assert wrongs in 0..9
  end

  test "Play again patches and resets won state while preserving score (per current reset_game/1)",
       %{conn: conn} do
    {:ok, view, _html} = live(conn, @route)

    # Win first (same deterministic technique)
    score_before_restart =
      Enum.reduce_while(1..10, nil, fn n, _ ->
        html = render_click(element(view, "a", Integer.to_string(n)))

        if html =~ "You Won!" do
          {:halt, score_from(html)}
        else
          {:cont, nil}
        end
      end)

    assert is_integer(score_before_restart)
    assert has_element?(view, "a", "Play again")

    # Click the patch link
    render_click(element(view, "a", "Play again"))

    # Assert we are patched (no full redirect)
    assert_patch(view, "/guess?restart=1")

    # After patch, game should be playable again (won? false) and message reset
    html_after = render(view)
    assert html_after =~ "Make a guess:"
    refute html_after =~ "You Won!"
    assert has_element?(view, ~s|a[phx-click="guess"]|, "1")

    # Your current reset_game keeps score as-is. Verify that behavior.
    assert score_from(html_after) == score_before_restart
  end

  defp score_from(html) when is_binary(html) do
    # Matches: "Your score: 0" or "Your score: -3"
    case Regex.run(~r/Your score:\s*(-?\d+)/, html) do
      [_, score] -> String.to_integer(score)
      _ -> flunk("Could not parse score from HTML:\n#{html}")
    end
  end
end
