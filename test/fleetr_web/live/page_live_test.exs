defmodule FleetrWeb.PageLiveTest do
  use FleetrWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
  end
end
