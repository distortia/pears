defmodule PearsWeb.Plug.TestEndToEnd do
  use Plug.Router

  plug :match
  plug :dispatch

  post "/teams" do
    with conn <- Plug.Conn.fetch_query_params(conn),
         name <- Map.get(conn.params, "name"),
         {:ok, %{id: id}} <- Pears.add_team(name) do
      send_resp(conn, 200, id)
    else
      _ -> send_resp(conn, 200, "team already exists")
    end
  end

  delete "/teams/:id" do
    with conn <- Plug.Conn.fetch_query_params(conn),
         name <- Map.get(conn.params, "id"),
         {:ok, _} <- Pears.remove_team(name) do
      send_resp(conn, 200, "team removed")
    else
      _ -> send_resp(conn, 200, "team not found")
    end
  end

  match(_, do: send_resp(conn, 404, "not found"))
end
