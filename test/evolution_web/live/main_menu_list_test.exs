defmodule EvolutionWeb.MainMenuLiveTest do
  use EvolutionWeb.ConnCase

  test "generate the main menu", %{conn: conn} do
    conn = get(conn, "/")

    {:ok, document} = Floki.parse_document(html_response(conn, 200))
    menu = Floki.find(document, "nav") |> Floki.text()

    assert menu =~ "Dashboard"
    assert menu =~ "Genetic"
    assert menu =~ "Swarm"
    assert menu =~ "Neural network"
  end

  test "highlights dashboard", %{conn: conn} do
    conn = get(conn, "/")
    assert_menu_active html_response(conn, 200), "Dashboard"
  end

  test "highlights genetics", %{conn: conn} do
    conn = get(conn, "/genetics")
    assert_menu_active html_response(conn, 200), "Genetic"
  end

  test "highlights the genetics subpath", %{conn: conn} do
    conn = get(conn, "/genetics/n_queens")
    assert_menu_active html_response(conn, 200), "Genetic"
  end

  defp assert_menu_active(html, menu) do
    {:ok, document} = Floki.parse_document(html)

    active = Floki.find(document, "nav .active-menu-item") |> Floki.text() |> String.trim()
    assert active == menu
  end
end
