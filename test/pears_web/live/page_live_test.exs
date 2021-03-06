defmodule PearsWeb.PageLiveTest do
  use PearsWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Pears.dev"
    assert render(page_live) =~ "Pears.dev"
  end
end
