#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule Pento.SurveyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Survey` context.
  """

  import Pento.CatalogFixtures

  @doc """
  Generate a demographic.
  """
  def demographic_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        gender: "male",
        year_of_birth: 1990
      })

    {:ok, demographic} = Pento.Survey.create_demographic(scope, attrs)
    demographic
  end

  @doc """
  Generate a rating.
  """
  def rating_fixture(scope, attrs \\ %{}) do
    product = product_fixture(scope)

    attrs =
      Enum.into(attrs, %{
        stars: 4,
        product_id: product.id
      })

    {:ok, rating} = Pento.Survey.create_rating(scope, attrs)
    rating
  end
end
