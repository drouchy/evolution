defmodule Evolution.Swarm.AntColony.Ant do
  alias Evolution.Utils.RouletteWheel

  def traverse(probabilities) do
    {first, rest} = initialise(probabilities)
    iterate(first, rest, probabilities)
  end

  defp iterate(current, [last], _), do: Enum.reverse([last | current])
  defp iterate(current = [head| _], rest, probabilities) do
    weights = Enum.map(rest, fn col -> Matrex.at(probabilities, head + 1, col + 1) end)
    index   = RouletteWheel.spin(weights)
    next    = Enum.at(rest, index)

    iterate([next | current], rest -- [next], probabilities)
  end

  defp initialise(probabilities) do
    {size, _} = Matrex.size(probabilities)

    genes = 0..(size - 1) |> Enum.to_list()
    first = Enum.take_random(genes, 1)
    rest  = genes -- first

    {first, rest}
  end
end
