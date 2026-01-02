#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule Pento.Survey do
  @moduledoc """
  The Survey context.
  """

  import Ecto.Query, warn: false
  alias Pento.Repo

  alias Pento.Survey.Demographic
  alias Pento.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any demographic changes.

  The broadcasted messages match the pattern:

    * {:created, %Demographic{}}
    * {:updated, %Demographic{}}
    * {:deleted, %Demographic{}}

  """
  def subscribe_demographics(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Pento.PubSub, "user:#{key}:demographics")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Pento.PubSub, "user:#{key}:demographics", message)
  end

  @doc """
  Returns the list of demographics.

  ## Examples

      iex> list_demographics(scope)
      [%Demographic{}, ...]

  """
  def list_demographics(%Scope{} = scope) do
    Repo.all(from demographic in Demographic, where: demographic.user_id == ^scope.user.id)
  end

  @doc """
  Gets a single demographic.

  Raises `Ecto.NoResultsError` if the Demographic does not exist.

  ## Examples

      iex> get_demographic!(123)
      %Demographic{}

      iex> get_demographic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_demographic!(%Scope{} = scope, id) do
    Repo.get_by!(Demographic, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a demographic.

  ## Examples

      iex> create_demographic(%{field: value})
      {:ok, %Demographic{}}

      iex> create_demographic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_demographic(%Scope{} = scope, attrs \\ %{}) do
    with {:ok, demographic = %Demographic{}} <-
           %Demographic{}
           |> Demographic.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast(scope, {:created, demographic})
      {:ok, demographic}
    end
  end

  @doc """
  Updates a demographic.

  ## Examples

      iex> update_demographic(demographic, %{field: new_value})
      {:ok, %Demographic{}}

      iex> update_demographic(demographic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_demographic(%Scope{} = scope, %Demographic{} = demographic, attrs) do
    true = demographic.user_id == scope.user.id

    with {:ok, demographic = %Demographic{}} <-
           demographic
           |> Demographic.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, demographic})
      {:ok, demographic}
    end
  end

  @doc """
  Deletes a demographic.

  ## Examples

      iex> delete_demographic(demographic)
      {:ok, %Demographic{}}

      iex> delete_demographic(demographic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_demographic(%Scope{} = scope, %Demographic{} = demographic) do
    true = demographic.user_id == scope.user.id

    with {:ok, demographic = %Demographic{}} <-
           Repo.delete(demographic) do
      broadcast(scope, {:deleted, demographic})
      {:ok, demographic}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking demographic changes.

  ## Examples

      iex> change_demographic(demographic)
      %Ecto.Changeset{data: %Demographic{}}

  """
  def change_demographic(%Scope{} = scope, %Demographic{} = demographic, attrs \\ %{}) do
    true = demographic.user_id == scope.user.id

    Demographic.changeset(demographic, attrs, scope)
  end

  alias Pento.Survey.Rating
  alias Pento.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any rating changes.

  The broadcasted messages match the pattern:

    * {:created, %Rating{}}
    * {:updated, %Rating{}}
    * {:deleted, %Rating{}}

  """
  def subscribe_ratings(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Pento.PubSub, "user:#{key}:ratings")
  end

  @doc """
  Returns the list of ratings.

  ## Examples

      iex> list_ratings(scope)
      [%Rating{}, ...]

  """
  def list_ratings(%Scope{} = scope) do
    Repo.all(from rating in Rating, where: rating.user_id == ^scope.user.id)
  end

  @doc """
  Gets a single rating.

  Raises `Ecto.NoResultsError` if the Rating does not exist.

  ## Examples

      iex> get_rating!(123)
      %Rating{}

      iex> get_rating!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rating!(%Scope{} = scope, id) do
    Repo.get_by!(Rating, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a rating.

  ## Examples

      iex> create_rating(%{field: value})
      {:ok, %Rating{}}

      iex> create_rating(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rating(%Scope{} = scope, attrs \\ %{}) do
    with {:ok, rating = %Rating{}} <-
           %Rating{}
           |> Rating.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast(scope, {:created, rating})
      {:ok, rating}
    end
  end

  @doc """
  Updates a rating.

  ## Examples

      iex> update_rating(rating, %{field: new_value})
      {:ok, %Rating{}}

      iex> update_rating(rating, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rating(%Scope{} = scope, %Rating{} = rating, attrs) do
    true = rating.user_id == scope.user.id

    with {:ok, rating = %Rating{}} <-
           rating
           |> Rating.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, rating})
      {:ok, rating}
    end
  end

  @doc """
  Deletes a rating.

  ## Examples

      iex> delete_rating(rating)
      {:ok, %Rating{}}

      iex> delete_rating(rating)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rating(%Scope{} = scope, %Rating{} = rating) do
    true = rating.user_id == scope.user.id

    with {:ok, rating = %Rating{}} <-
           Repo.delete(rating) do
      broadcast(scope, {:deleted, rating})
      {:ok, rating}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rating changes.

  ## Examples

      iex> change_rating(rating)
      %Ecto.Changeset{data: %Rating{}}

  """
  def change_rating(%Scope{} = scope, %Rating{} = rating, attrs \\ %{}) do
    true = rating.user_id == scope.user.id

    Rating.changeset(rating, attrs, scope)
  end

  @doc """
  Gets a demographic for the given user scope.

  Returns nil if no demographic exists for the user.
  """
  def get_demographic_by_user(%Scope{} = scope) do
    Repo.one(
      from demographic in Demographic,
      where: demographic.user_id == ^scope.user.id
    )
  end
end
