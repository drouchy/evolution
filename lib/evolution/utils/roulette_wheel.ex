defmodule Evolution.Utils.RouletteWheel do
  def spin(fitness = [first | rest], settings \\ []) do
    random = Keyword.get(settings, :random, Evolution.Utils.UniformRandom.new(nil))

    values = rest
    |> Enum.reduce([first], fn value, acc = [head | _] -> [value + head | acc] end)
    |> Enum.reverse()
    sum = fitness |> Enum.sum() |> round()

    r = random.(sum)
    values ++ [sum]
    |> Enum.take_while(fn v -> v < r end)
    |> length()
  end
end
