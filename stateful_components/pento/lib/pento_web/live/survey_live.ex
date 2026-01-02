#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view

  alias Pento.{Survey, Catalog}
  alias PentoWeb.DemographicLive.{Show, Form}
  alias PentoWeb.RatingLive
  alias __MODULE__.Component

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_demographic()
      |> assign_products()

    {:ok, socket}
  end

  defp assign_demographic(socket) do
    demographic = Survey.get_demographic_by_user(socket.assigns.current_scope)
    assign(socket, :demographic, demographic)
  end

  defp assign_products(socket) do
    user = socket.assigns.current_scope.user
    products = Catalog.list_products_with_user_rating(user)
    assign(socket, :products, products)
  end

  @impl true
  def handle_info({:created_demographic, demographic}, socket) do
    socket = handle_demographic_created(socket, demographic)
    {:noreply, socket}
  end

  def handle_info({:created_rating, product, product_index}, socket) do
    socket = handle_rating_created(socket, product, product_index)
    {:noreply, socket}
  end

  defp handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end

  defp handle_rating_created(socket, product, product_index) do
    current_products = socket.assigns.products
    products = List.replace_at(current_products, product_index, product)

    socket
    |> put_flash(:info, "Rating created successfully")
    |> assign(:products, products)
  end
end
