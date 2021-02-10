defmodule Evolution.Swarm.AntColony do
  @alpha 1
  @beta  0.01
  @rho   0.02

  alias Evolution.Swarm.AntColony.{Trip, Ant, Pheromones}

  def solve(problem, settings \\ []) do
    weights      = problem.weights(settings[:cities])
    pheromones   = Pheromones.initialise(settings[:problem_size])

    {_, _, best} = Enum.reduce(1..settings[:max_iteration], {weights, pheromones, %Trip{path: [], fitness: :infinity}}, fn iteration, {weights, pheromones, champion} ->
      w = Matrex.multiply(weights, @alpha)
      p = Matrex.multiply(pheromones, @beta)
      fitness = Matrex.multiply(w, p)

      ants = 1..settings[:population_size]
      |> Parallel.pmap(fn _ ->
        trip = Ant.traverse(fitness)
        %Trip{path: trip, fitness: problem.fitness(trip, settings)}
      end)

      pheromones = pheromones
      |> Pheromones.update(ants)
      |> Pheromones.evaporate(@rho)

      best_ant = ants
      |> Enum.sort(fn a, b -> a.fitness >= b.fitness end)
      |> hd()

      new_champion = cond do
        best_ant.fitness < champion.fitness -> best_ant
        true                                -> champion
      end

      if Integer.mod(iteration, 100) == 0, do: IO.puts "Iteration #{iteration}/#{settings[:max_iteration]} done"
      {weights, pheromones, new_champion}
    end)

    best
  end
end

defmodule Parallel do
  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end
