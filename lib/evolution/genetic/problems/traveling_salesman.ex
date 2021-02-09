defmodule Evolution.Genetic.Problems.TravelingSalesman do
  @behaviour Evolution.Genetic.Problem

  alias Evolution.Genetic.Chromosome

  @impl true
  def defaults(), do: [selection: "natural", crossover: "order_one", mutation: "scramble", re_insertion: "pure"]

  @impl true
  def genotype(%{size: size}) do
    genes = (0..size-1) |> Enum.to_list() |> Enum.shuffle()
    %Chromosome{genes: genes, size: size, fitness: size * -1}
  end

  @impl true
  def fitness(%Chromosome{genes: genes}, settings) do
    start = Enum.at(settings[:cities], hd(genes))
    genes
    |> Enum.map(& Enum.at(settings[:cities], &1))
    |> Enum.chunk_every(2, 1, [start])
    |> Enum.map(fn [p1, p2] -> distance(p1, p2) end)
    |> Enum.sum()
    |> Kernel.*(-1)
  end

  @impl true
  def terminate?(_, iteration, settings), do: Keyword.get(settings, :max_iteration, 10_000) == iteration

  defp distance(location_1, location_2), do: Geocalc.distance_between(location_1, location_2)
end
