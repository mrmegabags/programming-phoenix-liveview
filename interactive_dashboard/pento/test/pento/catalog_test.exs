#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule Pento.CatalogTest do
  use Pento.DataCase

  alias Pento.Catalog

  describe "products" do
    alias Pento.Catalog.Product

    import Pento.AccountsFixtures, only: [user_scope_fixture: 0]
    import Pento.CatalogFixtures

    @invalid_attrs %{name: nil, description: nil, unit_price: nil, sku: nil}

    test "list_products/1 returns all scoped products" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      product = product_fixture(scope)
      other_product = product_fixture(other_scope)
      assert Catalog.list_products(scope) == [product]
      assert Catalog.list_products(other_scope) == [other_product]
    end

    test "get_product!/2 returns the product with given id" do
      scope = user_scope_fixture()
      product = product_fixture(scope)
      other_scope = user_scope_fixture()
      assert Catalog.get_product!(scope, product.id) == product
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(other_scope, product.id) end
    end

    test "create_product/2 with valid data creates a product" do
      valid_attrs = %{name: "some name", description: "some description", unit_price: 120.5, sku: 42}
      scope = user_scope_fixture()

      assert {:ok, %Product{} = product} = Catalog.create_product(scope, valid_attrs)
      assert product.name == "some name"
      assert product.description == "some description"
      assert product.unit_price == 120.5
      assert product.sku == 42
      assert product.user_id == scope.user.id
    end

    test "create_product/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.create_product(scope, @invalid_attrs)
    end

    test "update_product/3 with valid data updates the product" do
      scope = user_scope_fixture()
      product = product_fixture(scope)
      update_attrs = %{name: "some updated name", description: "some updated description", unit_price: 456.7, sku: 43}

      assert {:ok, %Product{} = product} = Catalog.update_product(scope, product, update_attrs)
      assert product.name == "some updated name"
      assert product.description == "some updated description"
      assert product.unit_price == 456.7
      assert product.sku == 43
    end

    test "update_product/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      product = product_fixture(scope)

      assert_raise MatchError, fn ->
        Catalog.update_product(other_scope, product, %{})
      end
    end

    test "update_product/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      product = product_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Catalog.update_product(scope, product, @invalid_attrs)
      assert product == Catalog.get_product!(scope, product.id)
    end

    test "delete_product/2 deletes the product" do
      scope = user_scope_fixture()
      product = product_fixture(scope)
      assert {:ok, %Product{}} = Catalog.delete_product(scope, product)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_product!(scope, product.id) end
    end

    test "delete_product/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      product = product_fixture(scope)
      assert_raise MatchError, fn -> Catalog.delete_product(other_scope, product) end
    end

    test "change_product/2 returns a product changeset" do
      scope = user_scope_fixture()
      product = product_fixture(scope)
      assert %Ecto.Changeset{} = Catalog.change_product(scope, product)
    end
  end
end
