defmodule EvolutionWeb.GeneticController do
  use EvolutionWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", page_title: "Genetic Algorithms")
  end
end
