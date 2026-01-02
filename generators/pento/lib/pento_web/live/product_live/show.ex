#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule PentoWeb.ProductLive.Show do
  use PentoWeb, :live_view

  alias Pento.Catalog

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Product {@product.id}
        <:subtitle>This is a product record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/products"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/products/#{@product}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit product
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@product.name}</:item>
        <:item title="Description">{@product.description}</:item>
        <:item title="Unit price">{@product.unit_price}</:item>
        <:item title="Sku">{@product.sku}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    Catalog.subscribe_products(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, "Show Product")
     |> assign(:product, Catalog.get_product!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Pento.Catalog.Product{id: id} = product},
        %{assigns: %{product: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :product, product)}
  end

  def handle_info(
        {:deleted, %Pento.Catalog.Product{id: id}},
        %{assigns: %{product: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current product was deleted.")
     |> push_navigate(to: ~p"/products")}
  end
end
