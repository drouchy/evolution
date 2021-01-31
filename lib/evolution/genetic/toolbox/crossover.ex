defmodule Evolution.Genetic.Toolbox.Crossover do
  alias Evolution.Genetic.Chromosome

  def single_point(parent_1, parent_2, settings) do
    random_function = random_function(settings)

    cross_over_point = random_function.(parent_1.size)

    {head_1, tail_1} = Enum.split(parent_1.genes, cross_over_point)
    {head_2, tail_2} = Enum.split(parent_2.genes, cross_over_point)

    [
      %Chromosome{genes: head_1 ++ tail_2, size: parent_1.size},
      %Chromosome{genes: head_2 ++ tail_1, size: parent_1.size}
    ]
  end

  def order_one(parent_1, parent_2, settings \\ []) do
    random_function = random_function(settings)

    # Get random range
    {i1, i2} =
      [random_function.(parent_1.size), random_function.(parent_1.size)]
      |> Enum.sort()
      |> List.to_tuple()

    # parent_2 contribution
    slice1 = Enum.slice(parent_1.genes, i1..i2)
    slice1_set = MapSet.new(slice1)
    parent_2_contrib = Enum.reject(parent_2.genes, &MapSet.member?(slice1_set, &1))
    {head1, tail1} = Enum.split(parent_2_contrib, i1)

    # parent_1 contribution
    slice2 = Enum.slice(parent_2.genes, i1..i2)
    slice2_set = MapSet.new(slice2)
    parent_1_contrib = Enum.reject(parent_1.genes, &MapSet.member?(slice2_set, &1))
    {head2, tail2} = Enum.split(parent_1_contrib, i1)

    [
      %Chromosome{
       genes: head1 ++ slice1 ++ tail1,
       size: parent_1.size
     },
     %Chromosome{
       genes: head2 ++ slice2 ++ tail2,
       size: parent_2.size
     }
    ]
  end

  def random_function([random: function]), do: function
  def random_function(_), do: fn max -> :rand.uniform(max) end
end
