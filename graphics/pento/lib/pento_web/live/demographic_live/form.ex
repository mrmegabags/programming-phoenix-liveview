#---
# Excerpted from "Programming Phoenix LiveView",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit https://pragprog.com/titles/liveview for more book information.
#---
defmodule PentoWeb.DemographicLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Demographic

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign_demographic()
      |> clear_form()

    {:ok, socket}
  end

  defp assign_demographic(
    %{assigns: %{current_scope: current_scope}} = socket) do
    assign(socket, :demographic, %Demographic{user_id: current_scope.user.id})
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp clear_form(%{assigns: %{demographic: demographic}} = socket) do
    current_scope = socket.assigns.current_scope
    changeset = Survey.change_demographic(current_scope, demographic)
    assign_form(socket, changeset)
  end

  @impl true
  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    params = params_with_user_id(demographic_params, socket)
    socket = save_demographic(socket, params)
    {:noreply, socket}
  end

  defp params_with_user_id(params, socket) do
    user_id = socket.assigns.current_scope.user.id
    Map.put(params, "user_id", user_id)
  end

  defp save_demographic(socket, demographic_params) do
    current_scope = socket.assigns.current_scope
    case Survey.create_demographic(current_scope, demographic_params) do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign_form(socket, changeset)
    end
  end
end
