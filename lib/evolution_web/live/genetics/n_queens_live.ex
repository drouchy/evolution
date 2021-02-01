defmodule EvolutionWeb.Genetics.NQueensLive do
  use EvolutionWeb, :live_view

  alias Evolution.Genetic.Problems.NQueens

  @default_size 10

  @impl true
  def mount(_params, _session, socket) do
    chromosome = NQueens.genotype(%{size: @default_size})
    conflicts  = NQueens.conflicts(chromosome)

    {:ok, assign(socket, page_title: "N-Queens", settings: %{size: @default_size}, genes: chromosome.genes, conflicts: conflicts)}
  end

  defp background_class(row, column), do: Integer.mod(row + column, 2) |> background_class()
  defp background_class(0), do: "bg-gray-300"
  defp background_class(1), do: "bg-white"
end
