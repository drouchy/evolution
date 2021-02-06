defmodule EvolutionWeb.Live.Genetics.KnapsackLiveTest do
  use EvolutionWeb.ConnCase
  import Phoenix.LiveViewTest

  test "assigns the page_title", %{conn: conn} do
    conn = get(conn, "/genetics/knapsack")
    {:ok, _, html} = live(conn)

    assert html =~ "<title>Knapsack</title>"
  end
end
