defmodule Evolution.Swarm.Ant do
  alias Evolution.Utils.RouletteWheel

  def traverse(probabilities) do
    {first, rest} = initialise(probabilities)
    iterate(first, rest, probabilities)
  end

  defp iterate(current, [last], _), do: Enum.reverse([last | current])
  defp iterate(current = [head| _], rest, probabilities) do
    row     = Enum.at(probabilities, head)
    weights = Enum.map(rest, &(Enum.at(row, &1)))
    index   = RouletteWheel.spin(weights)
    next    = Enum.at(rest, index)

    iterate([next | current], rest -- [next], probabilities)
  end

  defp initialise(probabilities) do
    genes = 0..(length(probabilities) - 1) |> Enum.to_list()
    first = Enum.take_random(genes, 1)
    rest  = genes -- first

    {first, rest}
  end
end
