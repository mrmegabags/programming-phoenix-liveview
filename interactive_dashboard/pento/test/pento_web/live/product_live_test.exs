#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule PentoWeb.ProductLiveTest do
  use PentoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pento.CatalogFixtures

  @create_attrs %{name: "some name", description: "some description", unit_price: 120.5, sku: 42}
  @update_attrs %{
    name: "some updated name",
    description: "some updated description",
    unit_price: 456.7,
    sku: 43
  }
  @invalid_attrs %{name: nil, description: nil, unit_price: nil, sku: nil}

  setup :register_and_log_in_user

  defp create_product(%{scope: scope}) do
    product = product_fixture(scope)

    %{product: product}
  end

  describe "Index" do
    setup [:create_product]

    test "lists all products", %{conn: conn, product: product} do
      {:ok, _index_live, html} = live(conn, ~p"/products")

      assert html =~ "Listing Products"
      assert html =~ product.name
    end

    test "saves new product", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/products")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Product")
               |> render_click()
               |> follow_redirect(conn, ~p"/products/new")

      assert render(form_live) =~ "New Product"

      assert form_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#product-form", product: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/products")

      html = render(index_live)
      assert html =~ "Product created successfully"
      assert html =~ "some name"
    end

    test "updates product in listing", %{conn: conn, product: product} do
      {:ok, index_live, _html} = live(conn, ~p"/products")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#products-#{product.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/products/#{product}/edit")

      assert render(form_live) =~ "Edit Product"

      assert form_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#product-form", product: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/products")

      html = render(index_live)
      assert html =~ "Product updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes product in listing", %{conn: conn, product: product} do
      {:ok, index_live, _html} = live(conn, ~p"/products")

      assert index_live |> element("#products-#{product.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#products-#{product.id}")
    end
  end

  describe "Show" do
    setup [:create_product]

    test "displays product", %{conn: conn, product: product} do
      {:ok, _show_live, html} = live(conn, ~p"/products/#{product}")

      assert html =~ "Show Product"
      assert html =~ product.name
    end

    test "updates product and returns to show", %{conn: conn, product: product} do
      {:ok, show_live, _html} = live(conn, ~p"/products/#{product}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/products/#{product}/edit?return_to=show")

      assert render(form_live) =~ "Edit Product"

      assert form_live
             |> form("#product-form", product: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#product-form", product: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/products/#{product}")

      html = render(show_live)
      assert html =~ "Product updated successfully"
      assert html =~ "some updated name"
    end
  end
end
