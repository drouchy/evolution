defmodule Evolution.Genetic.Settings do
  @defaults [
    selection: "natural",
    crossover: "single_point",
    mutation: "scramble",
    re_insertion: "pure",
    mutation_rate: 0.05,
    selection_rate: 1.0,
    survival_rate: 0.1,
    reporter: Evolution.Genetic.Reporters.BlackHoleReporter,
    random: Evolution.Utils.UniformRandom.new([])
  ]

  def defaults() do
    @defaults
  end
end
