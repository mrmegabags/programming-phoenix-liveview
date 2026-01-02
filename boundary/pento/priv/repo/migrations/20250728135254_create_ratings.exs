#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule Pento.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :stars, :integer
      add :user_id, references(:users, type: :id, on_delete: :delete_all)
      add :product_id, references(:products, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:ratings, [:user_id])
    create index(:ratings, [:product_id])
    create unique_index(:ratings, [:user_id, :product_id])
  end
end
