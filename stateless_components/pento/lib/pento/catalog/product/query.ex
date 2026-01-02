#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule Pento.Catalog.Product.Query do
  import Ecto.Query
  alias Pento.Catalog.Product
  alias Pento.Survey.Rating.Query, as: RatingQuery

  def base, do: Product

  def with_user_ratings(query, user) do
    ratings_query = RatingQuery.preload_user(user)

    from(p in query, preload: [ratings: ^ratings_query])
  end
end
