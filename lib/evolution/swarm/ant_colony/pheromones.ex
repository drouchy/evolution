defmodule Evolution.Swarm.AntColony.Pheromones do
  alias Evolution.Swarm.AntColony.Trip

  def initialise(size, settings \\ []) do
    random = Keyword.get(settings, :random, Evolution.Utils.UniformRandom.new(nil))

    Matrex.new(size, size, fn -> random.(1) end)
    |> Matrex.multiply(0.01)
  end

  def update(pheromones, ants) when is_list(ants) do
    Enum.reduce(ants, pheromones, &(update(&2, &1)))
  end

  def update(pheromones, %Trip{path: path = [start | _], fitness: fitness}) do
    delta = 1.0 / fitness
    additional = Matrex.zeros(Matrex.size(pheromones))

    additional = path
    |> Enum.chunk_every(2, 1, [start])
    |> Enum.reduce(additional, fn [i, j], acc -> Matrex.set(acc, i + 1, j + 1, delta) end)

    Matrex.add(pheromones, additional)
  end

end
