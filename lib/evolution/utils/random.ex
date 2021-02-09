defmodule Evolution.Utils.Random do
  @callback new(Keyword.t) :: function()
end

defmodule Evolution.Utils.UniformRandom do
  @behaviour Evolution.Utils.Random

  def new(_), do: &:rand.uniform/1
end

defmodule Evolution.Utils.UniformRandomReal do
  @behaviour Evolution.Utils.Random

  def new(_), do: fn max -> :rand.uniform_real() * max end
end
