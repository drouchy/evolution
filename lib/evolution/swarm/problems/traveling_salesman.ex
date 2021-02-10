defmodule Evolution.Swarm.Problems.TravelingSalesman do

  def weights(cities) do
    Matrex.new(length(cities), length(cities), fn row, col ->
      distance(Enum.at(cities, row - 1), Enum.at(cities, col - 1))
    end)
  end

  def fitness(values, settings) do
    start = Enum.at(settings[:cities], hd(values))
    values
    |> Enum.map(& Enum.at(settings[:cities], &1))
    |> Enum.chunk_every(2, 1, [start])
    |> Enum.map(fn [p1, p2] -> distance(p1, p2) end)
    |> Enum.sum()
  end

  defp distance(location_1, location_2), do: Geocalc.distance_between(location_1, location_2)
end
