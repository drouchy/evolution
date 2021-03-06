defmodule Evolution.Utils.RouletteWheel do
  def spin(fitness = [first | rest], settings \\ []) do
    random = Keyword.get(settings, :random, Evolution.Utils.UniformRandomReal.new(nil))

    values = rest
    |> Enum.reduce([first], fn value, acc = [head | _] -> [value + head | acc] end)
    |> Enum.reverse()
    sum = fitness |> Enum.sum()

    r = random.(sum)
    values
    |> Enum.take_while(fn v -> v < r end)
    |> length()
  end
end
