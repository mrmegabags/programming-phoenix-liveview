#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule PentoWeb.RatingLive.Index do
  use Phoenix.Component
  alias PentoWeb.RatingLive

  attr :products, :list, required: true
  attr :current_scope, :map, required: true

  def product_list(assigns) do
    ~H"""
    <.heading products={@products} current_scope={@current_scope} />
    <div class="divide-y">
      <.product_rating
        :for={{product, index} <- Enum.with_index(@products)}
        product={product}
        index={index}
        current_scope={@current_scope} />
    </div>
    """
  end

  attr :products, :list, required: true
  attr :current_scope, :map, required: true

  def heading(assigns) do
    ~H"""
    <h2 class="flex justify-between">
      Ratings
      <%= if ratings_complete?(@products, @current_scope) do %>
        ✅
      <% end %>
    </h2>
    """
  end

  def ratings_complete?(products, current_scope) do
    Enum.all?(products, fn product ->
      Enum.any?(product.ratings, &(&1.user_id == current_scope.user.id))
    end)
  end

  attr :product, :map, required: true
  attr :index, :integer, required: true
  attr :current_scope, :map, required: true

  def product_rating(assigns) do
    ~H"""
    <div class="py-0">
      <div><%= @product.name %></div>
      <%= if rating = List.first(@product.ratings) do %>
        <RatingLive.Show.stars rating={rating} />
      <% else %>
        <.live_component
          module={RatingLive.Form}
          id={"rating-form-#{@product.id}"}
          product={@product}
          index={@index}
          current_scope={@current_scope} />
      <% end %>
    </div>
    """
  end
end
