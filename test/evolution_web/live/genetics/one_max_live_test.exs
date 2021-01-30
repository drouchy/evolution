defmodule EvolutionWeb.Live.Genetics.OneMaxLiveTest do
  use EvolutionWeb.ConnCase
  import Phoenix.LiveViewTest

  test "assigns the page_title", %{conn: conn} do
    conn = get(conn, "/genetics/one_max")
    {:ok, _, html} = live(conn)

    assert html =~ "<title>One Max</title>"
  end
end
