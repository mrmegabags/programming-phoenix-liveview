#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule PentoWeb.ProductLive.Index do
  use PentoWeb, :live_view

  alias Pento.Catalog

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <h1 class="text-2xl font-bold">{@greeting}</h1>
      <.header>
        Listing Products
        <:actions>
          <.button variant="primary" navigate={~p"/products/new"}>
            <.icon name="hero-plus" /> New Product
          </.button>
        </:actions>
      </.header>

      <.table
        id="products"
        rows={@streams.products}
        row_click={fn {_id, product} ->
          JS.navigate(~p"/products/#{product}")
        end}
      >
        <:col :let={{_id, product}} label="Name">{product.name}</:col>
        <:col
          :let={{_id, product}}
          label="Description">{product.description}
        </:col>
        <:col
          :let={{_id, product}}
          label="Unit price">{product.unit_price}
        </:col>
        <:col :let={{_id, product}} label="Sku">{product.sku}</:col>
        <:action :let={{_id, product}}>
          <div class="sr-only">
            <.link navigate={~p"/products/#{product}"}>Show</.link>
          </div>
          <.link navigate={~p"/products/#{product}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, product}}>
          <.link
            phx-click={
              JS.push("delete", value: %{id: product.id})
              |> hide("##{id}")
            }
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    Catalog.subscribe_products(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, "Listing Products")
     |> assign(:greeting, "Welcome to Pento!")
     |> stream(:products, Catalog.list_products(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Catalog.get_product!(socket.assigns.current_scope, id)
    {:ok, _} = Catalog.delete_product(socket.assigns.current_scope, product)

    {:noreply, stream_delete(socket, :products, product)}
  end

  @impl true
  def handle_info({type, %Pento.Catalog.Product{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply,
     stream(socket, :products,
            Catalog.list_products(socket.assigns.current_scope), reset: true)}
  end
end
