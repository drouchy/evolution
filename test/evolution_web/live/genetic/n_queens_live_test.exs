defmodule EvolutionWeb.Live.Genetics.NQueensLiveTest do
  use EvolutionWeb.ConnCase
  import Phoenix.LiveViewTest

  test "assigns the page_title", %{conn: conn} do
    conn = get(conn, "/genetics/n_queens")
    {:ok, _, html} = live(conn)

    assert html =~ "<title>N-Queens</title>"
  end

  test "builds the board", %{conn: conn} do
    conn = get(conn, "/genetics/n_queens")
    {:ok, _, html} = live(conn)

    {:ok, document} = Floki.parse_document(html)

    board = Floki.find(document, "#board")
    rows =  Floki.find(board, "tr")

    assert length(rows) == 10
    assert length(Floki.find(hd(rows), "td")) == 10

    assert length(Floki.find(document, "#board tr td.bg-gray-300")) == 50
    assert length(Floki.find(document, "#board tr td.bg-white"))    == 50

    assert length(Floki.find(document, ".fa-chess-queen")) == 10
    assert length(Floki.find(document, ".text-red-600")) > 0
  end
end
