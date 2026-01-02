#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
# Run this script with: mix run priv/repo/rating_seeds.exs
alias Pento.{Repo, Accounts, Survey}
alias Pento.Accounts.{User, Scope}
alias Pento.Survey.{Demographic, Rating}
alias Pento.Catalog.Product

users =
  for i <- 1..43, do:
    Accounts.register_user(%{
      email: "user#{i}@example.com",
      password: "passwordpassword"
    })

user_ids = Repo.all(User) |> Enum.map(& &1.id)

product_ids = Repo.all(Product) |> Enum.map(& &1.id)
genders = ["male", "female", "other", "prefer not to say"]
years = 1950..2005 |> Enum.to_list()
stars = 1..5 |> Enum.to_list()

for user_id <- user_ids do
  scope = %Scope{user: %User{id: user_id}}
  gender = Enum.random(genders)
  year_of_birth = Enum.random(years)

  Survey.create_demographic(scope, %{
    gender: gender,
    year_of_birth: year_of_birth
  })
end

# Create ratings for users and products
for user_id <- user_ids,
    product_id <- product_ids,
    Enum.random([true, false, false]) do

  # Check if rating already exists
  existing = Repo.get_by(Rating, user_id: user_id, product_id: product_id)

  unless existing do
    %Rating{}
    |> Rating.changeset(%{
      user_id: user_id,
      product_id: product_id,
      stars: Enum.random(stars)
    })
    |> Repo.insert()
  end
end
