#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule Pento.SurveyTest do
  use Pento.DataCase

  alias Pento.Survey

  describe "demographics" do
    alias Pento.Survey.Demographic

    import Pento.AccountsFixtures, only: [user_scope_fixture: 0]
    import Pento.SurveyFixtures

    @invalid_attrs %{gender: nil, year_of_birth: nil}

    test "list_demographics/1 returns all scoped demographics" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      demographic = demographic_fixture(scope)
      other_demographic = demographic_fixture(other_scope)
      assert Survey.list_demographics(scope) == [demographic]
      assert Survey.list_demographics(other_scope) == [other_demographic]
    end

    test "get_demographic!/2 returns the demographic with given id" do
      scope = user_scope_fixture()
      demographic = demographic_fixture(scope)
      other_scope = user_scope_fixture()
      assert Survey.get_demographic!(scope, demographic.id) == demographic
      assert_raise Ecto.NoResultsError, fn -> Survey.get_demographic!(other_scope, demographic.id) end
    end

    test "create_demographic/2 with valid data creates a demographic" do
      valid_attrs = %{gender: "male", year_of_birth: 1990}
      scope = user_scope_fixture()

      assert {:ok, %Demographic{} = demographic} = Survey.create_demographic(scope, valid_attrs)
      assert demographic.gender == "male"
      assert demographic.year_of_birth == 1990
      assert demographic.user_id == scope.user.id
    end

    test "create_demographic/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Survey.create_demographic(scope, @invalid_attrs)
    end

    test "update_demographic/3 with valid data updates the demographic" do
      scope = user_scope_fixture()
      demographic = demographic_fixture(scope)
      update_attrs = %{gender: "female", year_of_birth: 1985}

      assert {:ok, %Demographic{} = demographic} = Survey.update_demographic(scope, demographic, update_attrs)
      assert demographic.gender == "female"
      assert demographic.year_of_birth == 1985
    end

    test "update_demographic/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      demographic = demographic_fixture(scope)

      assert_raise MatchError, fn ->
        Survey.update_demographic(other_scope, demographic, %{})
      end
    end

    test "update_demographic/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      demographic = demographic_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Survey.update_demographic(scope, demographic, @invalid_attrs)
      assert demographic == Survey.get_demographic!(scope, demographic.id)
    end

    test "delete_demographic/2 deletes the demographic" do
      scope = user_scope_fixture()
      demographic = demographic_fixture(scope)
      assert {:ok, %Demographic{}} = Survey.delete_demographic(scope, demographic)
      assert_raise Ecto.NoResultsError, fn -> Survey.get_demographic!(scope, demographic.id) end
    end

    test "delete_demographic/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      demographic = demographic_fixture(scope)
      assert_raise MatchError, fn -> Survey.delete_demographic(other_scope, demographic) end
    end

    test "change_demographic/2 returns a demographic changeset" do
      scope = user_scope_fixture()
      demographic = demographic_fixture(scope)
      assert %Ecto.Changeset{} = Survey.change_demographic(scope, demographic)
    end
  end

  describe "ratings" do
    alias Pento.Survey.Rating

    import Pento.AccountsFixtures, only: [user_scope_fixture: 0]
    import Pento.SurveyFixtures

    @invalid_attrs %{stars: nil}

    test "list_ratings/1 returns all scoped ratings" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      rating = rating_fixture(scope)
      other_rating = rating_fixture(other_scope)
      assert Survey.list_ratings(scope) == [rating]
      assert Survey.list_ratings(other_scope) == [other_rating]
    end

    test "get_rating!/2 returns the rating with given id" do
      scope = user_scope_fixture()
      rating = rating_fixture(scope)
      other_scope = user_scope_fixture()
      assert Survey.get_rating!(scope, rating.id) == rating
      assert_raise Ecto.NoResultsError, fn -> Survey.get_rating!(other_scope, rating.id) end
    end

    test "create_rating/2 with valid data creates a rating" do
      valid_attrs = %{stars: 4}
      scope = user_scope_fixture()

      assert {:ok, %Rating{} = rating} = Survey.create_rating(scope, valid_attrs)
      assert rating.stars == 4
      assert rating.user_id == scope.user.id
    end

    test "create_rating/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Survey.create_rating(scope, @invalid_attrs)
    end

    test "update_rating/3 with valid data updates the rating" do
      scope = user_scope_fixture()
      rating = rating_fixture(scope)
      update_attrs = %{stars: 5}

      assert {:ok, %Rating{} = rating} = Survey.update_rating(scope, rating, update_attrs)
      assert rating.stars == 5
    end

    test "update_rating/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      rating = rating_fixture(scope)

      assert_raise MatchError, fn ->
        Survey.update_rating(other_scope, rating, %{})
      end
    end

    test "update_rating/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      rating = rating_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Survey.update_rating(scope, rating, @invalid_attrs)
      assert rating == Survey.get_rating!(scope, rating.id)
    end

    test "delete_rating/2 deletes the rating" do
      scope = user_scope_fixture()
      rating = rating_fixture(scope)
      assert {:ok, %Rating{}} = Survey.delete_rating(scope, rating)
      assert_raise Ecto.NoResultsError, fn -> Survey.get_rating!(scope, rating.id) end
    end

    test "delete_rating/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      rating = rating_fixture(scope)
      assert_raise MatchError, fn -> Survey.delete_rating(other_scope, rating) end
    end

    test "change_rating/2 returns a rating changeset" do
      scope = user_scope_fixture()
      rating = rating_fixture(scope)
      assert %Ecto.Changeset{} = Survey.change_rating(scope, rating)
    end
  end
end
