#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule Pento.Survey.Rating.Query do
  import Ecto.Query
  alias Pento.Survey.Rating

  def preload_user(user) do
    from(r in Rating, where: r.user_id == ^user.id)
  end
end
