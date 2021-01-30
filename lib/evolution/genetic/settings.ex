defmodule Evolution.Genetic.Settings do
  @defaults [
    selection: &Evolution.Genetic.Toolbox.Selection.natural/2,
    crossover: &Evolution.Genetic.Toolbox.Crossover.single_point/3,
    mutation: &Evolution.Genetic.Toolbox.Mutation.scramble/2,
    re_insertion: &Evolution.Genetic.Toolbox.ReInsertion.pure/4,
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
