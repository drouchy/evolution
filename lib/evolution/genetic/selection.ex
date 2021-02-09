defmodule Evolution.Genetic.Selection do
  def natural(population, settings) do
    total = Enum.count(population)
    size = total * Keyword.get(settings, :ratio, 1.0) |> Kernel.trunc()
    size = case rem(size, 2) do
      1 -> size - 1
      0 -> size
    end

    parents = Enum.take(population, size)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [a, b] -> { a, b} end)

    leftovers = Enum.slice(population, size..total)

    {parents, leftovers}
  end
end
