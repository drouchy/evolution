defmodule Evolution.Genetic do
  alias Evolution.Genetic.Population

  @defaults [
    mutation_rate: 0.05,
    selection_rate: 1.0,
    survival_rate: 0.1,
    reporter: Evolution.Genetic.Reporters.BlackHoleReporter,
    random: Evolution.Utils.UniformRandom.new([])
  ]

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
    all_settings = @defaults
    |> Keyword.merge(problem.defaults())
    |> Keyword.merge(settings)

    all_settings = Keyword.merge(all_settings,
      [
        selection:    Function.capture(Evolution.Genetic.Toolbox.Selection,   String.to_atom(all_settings[:selection]), 2),
        crossover:    Function.capture(Evolution.Genetic.Toolbox.Crossover,   String.to_atom(all_settings[:crossover]), 3),
        mutation:     Function.capture(Evolution.Genetic.Toolbox.Mutation,    String.to_atom(all_settings[:mutation]), 2),
        re_insertion: Function.capture(Evolution.Genetic.Toolbox.ReInsertion, String.to_atom(all_settings[:re_insertion]), 4),
      ]
    )
    all_settings[:reporter].init(settings)

    run(problem, population, all_settings)
  end

  def available_strategies(role) do
    case role do
      :selection     -> check_strategies(Evolution.Genetic.Toolbox.Selection, 2)
      :crossover     -> check_strategies(Evolution.Genetic.Toolbox.Crossover, 3)
      :mutation      -> check_strategies(Evolution.Genetic.Toolbox.Mutation, 2)
      :re_insertion  -> check_strategies(Evolution.Genetic.Toolbox.ReInsertion, 4)
      _              -> {:error, :not_valid}
    end
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

  defp report_event(population, event, settings) do
    apply(settings[:reporter], event, [population, settings])
    population
  end

  defp check_strategies(module, arity) do
    module.__info__(:functions)
    |> Enum.filter(fn {_, a} -> arity == a end)
    |> Enum.map(fn {name, _} -> "#{name}" end)
  end
end
