defmodule Evolution.Genetic.Toolbox.ReInsertion do
  def pure(_parents, offspring, _leftovers, _settings \\ []) do
    offspring
  end

  def elitist(parents, offspring, leftovers, settings \\ []) do
    old = parents ++ leftovers
    n = floor(length(old) * settings[:survival_rate])

    survivors =
      old
      |> Enum.sort(&(&1.fitness >= &2.fitness))
      |> Enum.take(n)

    offspring ++ survivors
  end
end
