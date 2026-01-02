# ---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
# ---
defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        score: 0,
        message: "Make a guess:",
        time: time(),
        won?: false,
        answer: Enum.random(1..10)
      )

    IO.inspect(socket)
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      if Map.has_key?(params, "restart") do
        reset_game(socket)
      else
        socket
      end

    {:noreply, socket}
  end

  defp reset_game(socket) do
    assign(socket,
      score: socket.assigns.score,
      message: "Make a guess:",
      time: time(),
      won?: false,
      answer: Enum.random(1..10)
    )
  end

  def render(assigns) do
    ~H"""
     <main class="px-4 py-20 sm:px-6 lg:px-8">
    <h1 class="mb-4 text-4xl font-extrabold">Your score: {@score}</h1>
    <h2>
      {@message}
      It's time {@time}
    </h2>

    <br />

    <%= if @won? do %>
    <div class="mt-6">
        <.link class="btn btn-primary" patch={~p"/guess?restart=1"}>
          Play again
        </.link>
      </div>
      <% else %>
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          class="btn btn-secondary"
          phx-click="guess"
          phx-value-number={n}
        >
          {n}
        </.link>
      <% end %>
    </h2>
    <% end %>
    </main>
    """
  end

  def time do
    DateTime.utc_now() |> to_string()
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    guess = String.to_integer(guess)

    if guess == socket.assigns.answer do
      {:noreply,
       assign(socket,
         won?: true,
         message: "You Won!",
         score: socket.assigns.score + 1,
         time: time()
       )}
    else
      {
        :noreply,
        assign(
          socket,
          message: "Your guess: #{guess}. Wrong. Guess again. ",
          score: socket.assigns.score - 1,
          time: time()
        )
      }
    end
  end
end
