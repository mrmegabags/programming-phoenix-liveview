#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule PentoWeb.DemographicLive.Show do
  use Phoenix.Component
  alias PentoWeb.CoreComponents

  attr :demographic, :map, required: true

  def details(assigns) do
    ~H"""
    <h2>Demographics ✅</h2>
    <CoreComponents.table id="demographics" rows={[@demographic]}>
      <:col :let={demographic} label="Gender">
        <%= demographic.gender %>
      </:col>
      <:col :let={demographic} label="Year of Birth">
        <%= demographic.year_of_birth %>
      </:col>
    </CoreComponents.table>
    """
  end
end
