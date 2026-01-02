#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view
  def mount(_params, _session, socket) do
    # current_scope is automatically available thanks to on_mount callback
    user = socket.assigns.current_scope.user
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Guess a number.",
        current_user: user
      )
    }
  end

  def render(assigns) do
    ~H"""
     <main class="px-4 py-20 sm:px-6 lg:px-8">
    <h1 class="mb-4 text-4xl font-extrabold">Your score: {@score}</h1>
    <h2>
      {@message}
    </h2>
    <br />
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
    <h2>
      {@current_user.email}
    </h2>
    </main>
    """
  end


  def handle_event("guess", %{"number" => guess}, socket) do
    message = "Your guess: #{guess}. Wrong. Guess again. "
    score = socket.assigns.score - 1

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score
      )
    }
  end

end

