defmodule Evolution.Genetic.Toolbox.Mutation do

  alias Evolution.Genetic.Chromosome

  def scramble(chromosome, _settings \\ []) do
    %Chromosome{
      genes: Enum.shuffle(chromosome.genes),
      size: chromosome.size
    }
  end
end
