defmodule PearsWeb.TeamLive do
  use PearsWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign_team_or_redirect(params)
     |> assign(:selected_pear, nil)
     |> apply_action(socket.assigns.live_action)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action)}
  end

  @impl true
  def handle_event("recommend-pears", _params, socket) do
    {:ok, team} = Pears.recommend_pears(socket.assigns.team.name)
    {:noreply, assign(socket, :team, team)}
  end

  @impl true
  def handle_event("remove-track", %{"track-name" => track_name}, socket) do
    {:ok, team} = Pears.remove_track(socket.assigns.team.name, track_name)
    {:noreply, assign(socket, team: team)}
  end

  @impl true
  def handle_event("available-pear-selected", %{"pear-name" => pear_name}, socket) do
    {:noreply, assign(socket, selected_pear: pear_name)}
  end

  @impl true
  def handle_event("track-clicked", %{"track-name" => track_name}, socket) do
    case socket.assigns.selected_pear do
      nil ->
        {:noreply, socket}

      pear_name ->
        case Pears.add_pear_to_track(socket.assigns.team.name, pear_name, track_name) do
          {:ok, team} ->
            {:noreply, assign(socket, team: team, selected_pear: nil)}

          {:error, :not_found} ->
            {:noreply, socket}
        end
    end
  end

  defp assign_team_or_redirect(socket, %{"id" => id}) do
    case Pears.lookup_team_by(id: id) do
      {:ok, team} ->
        assign(socket, :team, team)

      {:error, :not_found} ->
        socket
        |> push_redirect(to: Routes.page_path(socket, :index))
        |> put_flash(:error, "Sorry, that team was not found")
    end
  end

  defp apply_action(socket, :show), do: socket
  defp apply_action(socket, :add_pear), do: socket
  defp apply_action(socket, :add_track), do: socket
end