defmodule Evolution.Genetic do
  alias Evolution.Genetic.Population
  alias Evolution.Genetic.Settings

  def initialise(problem, settings \\ []) do
    population_size = Keyword.get(settings, :population_size, 10)
    problem_size    = Keyword.get(settings, :problem_size, 10)

    chromosomes = (1..population_size)
      |> Enum.map(fn _ -> problem.genotype(%{size: problem_size}) end)
      |> Enum.map(fn c -> %{c| fitness: problem.fitness(c, settings)} end)

    %Population{
      chromosomes: chromosomes,
      size: population_size
    }
  end

  def solve(problem, population, settings \\ []) do
    all_settings = Keyword.merge(Settings.defaults(), settings)
    all_settings[:reporter].init(settings)

    run(problem, population, all_settings)
  end

  defp run(problem, population, settings) do
    report_event(population, :new_generation, settings)

    population = evaluate(population, settings)

    case problem.terminate?(population.champion, population.generation, settings) do
      true  ->
        settings[:reporter].solution_found(population, settings)
        population
      false ->
        {parents, leftovers} = settings[:selection].(population.chromosomes, settings)
        offspring = parents
          |> Enum.flat_map(fn {a, b} -> settings[:crossover].(a, b, settings) end)
          |> Enum.map(fn c ->
            cond do
              :rand.uniform() <= settings[:mutation_rate] ->
                settings[:mutation].(c, settings)
              true -> c
            end
          end)

        offspring = Enum.map(offspring, fn c -> %Evolution.Genetic.Chromosome{c | fitness: problem.fitness(c, settings)} end)

        parents = Enum.flat_map(parents, &Tuple.to_list/1)
        chromosomes = settings[:re_insertion].(parents, offspring, leftovers, settings)

        next_population = %Population{population | chromosomes: chromosomes, generation: population.generation + 1, size: length(chromosomes)}
        run(problem, next_population, settings)
    end
  end

  defp evaluate(population = %Population{chromosomes: chromosomes, champion: champion}, settings) do
    chromosomes = Enum.sort(chromosomes, &(&1.fitness >= &2.fitness))
    contestant = hd(chromosomes)

    cond do
      champion == nil                       ->
        %{population | chromosomes: chromosomes, champion: contestant}
          |> report_event(:new_champion, settings)
      champion.fitness < contestant.fitness ->
        %{population | chromosomes: chromosomes, champion: contestant}
          |> report_event(:new_champion, settings)
      true                                  ->
        %{population | chromosomes: chromosomes, champion: champion}
    end
  end

  def report_event(population, event, settings) do
    apply(settings[:reporter], event, [population, settings])
    population
  end
end
