#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule PentoWeb.RatingLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Rating
  alias PentoWeb.RatingLive

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_rating()
     |> assign_form()}
  end

  def assign_rating(socket) do
    rating = %Rating{user_id: socket.assigns.current_scope.user.id}
    assign(socket, :rating, rating)
  end

  def assign_form(socket, changeset \\ nil) do
    form =
      case changeset do
        nil ->
          current_scope = socket.assigns.current_scope
          rating = socket.assigns.rating
          to_form(Survey.change_rating(current_scope, rating))
        changeset -> to_form(changeset)
      end

    assign(socket, :form, form)
  end

  def handle_event("save", %{"rating" => rating_params}, socket) do
    save_rating(socket, rating_params)
  end

  def save_rating(socket, rating_params) do
    case Survey.create_rating(
           socket.assigns.current_scope,
           rating_params
           |> Map.put("product_id", socket.assigns.product.id)
         ) do
      {:ok, rating} ->
        product = %{socket.assigns.product | ratings: [rating]}
        send(self(), {:created_rating, product, socket.assigns.index})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end
end
