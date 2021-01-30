defmodule Evolution.Genetic.Population do
  alias Evolution.Genetic.Chromosome

  @type t :: %__MODULE__{
    id: String.t(),
    chromosomes: Enum.t(),
    generation: integer(),
    size: integer(),
    champion: Chromosome.t()
  }

  @enforce_keys [:chromosomes]
  defstruct [
    :chromosomes,
    id: Base.encode16(:crypto.strong_rand_bytes(64)),
    generation: 0,
    size: 0,
    champion: nil
  ]
end
