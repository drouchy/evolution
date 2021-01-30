defmodule Evolution.Genetic.Chromosome do

  @type t :: %__MODULE__{
    id: String.t(),
    genes: Enum.t,
    size: integer(),
    fitness: number() | :not_calculated,
    age: integer()
  }

  @enforce_keys :genes
  defstruct [:genes, :size, fitness: :not_calculated, id: Base.encode16(:crypto.strong_rand_bytes(64)), age: 0]
end
