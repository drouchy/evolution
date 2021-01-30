defmodule EvolutionWeb.GeneticControllerTest do
  use EvolutionWeb.ConnCase

  describe "get /genetics" do
    test "assigns the page title", %{conn: conn} do
      conn = get(conn, "/genetics")
      {:ok, document} = Floki.parse_document(html_response(conn, 200))

      assert Floki.find(document, "head title") |> Floki.text() == "Genetic Algorithms"
    end

    test "sets the page header", %{conn: conn} do
      conn = get(conn, "/genetics")
      {:ok, document} = Floki.parse_document(html_response(conn, 200))

      assert Floki.find(document, "header") |> Floki.text() |> String.trim() == "Genetic Algorithms"
    end


    test "show the list of the genetics problems", %{conn: conn} do
      conn = get(conn, "/genetics")

      assert html_response(conn, 200) =~ "N-Queens"
      assert html_response(conn, 200) =~ "/genetics/n_queens"

      assert html_response(conn, 200) =~ "Traveling Salesman"
      assert html_response(conn, 200) =~ "/genetics/traveling_salesman"

      assert html_response(conn, 200) =~ "Knapsack"
      assert html_response(conn, 200) =~ "/genetics/knapsack"

      assert html_response(conn, 200) =~ "One Max"
      assert html_response(conn, 200) =~ "/genetics/one_max"
    end
  end
end
