defmodule EvolutionWeb.Live.Genetics.TravelingSalesmanLiveTest do
  use EvolutionWeb.ConnCase
  import Phoenix.LiveViewTest

  test "assigns the page_title", %{conn: conn} do
    conn = get(conn, "/genetics/traveling_salesman")
    {:ok, _, html} = live(conn)

    assert html =~ "<title>Traveling Salesman</title>"
  end
end
