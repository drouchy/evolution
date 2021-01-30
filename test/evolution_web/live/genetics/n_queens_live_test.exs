defmodule EvolutionWeb.Live.Genetics.NQueensLiveTest do
  use EvolutionWeb.ConnCase
  import Phoenix.LiveViewTest

  test "assigns the page_title", %{conn: conn} do
    conn = get(conn, "/genetics/n_queens")
    {:ok, _, html} = live(conn)

    assert html =~ "<title>N-Queens</title>"
  end
end
