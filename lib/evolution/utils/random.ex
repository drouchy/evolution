defmodule Evolution.Utils.Random do
  @callback new(Keyword.t) :: function()
end

defmodule Evolution.Utils.UniformRandom do
  @behaviour Evolution.Utils.Random

  def new(_), do: &:rand.uniform/1
end
