defmodule EvolutionWeb.Genetic.NQueensLive do
  use EvolutionWeb, :live_view

  require Logger

  alias Evolution.Genetic
  alias Evolution.Genetic.Problems.NQueens

  @default_size 10

  @impl true
  def mount(_params, _session, socket) do
    chromosome = NQueens.genotype(%{size: @default_size})
    conflicts  = NQueens.conflicts(chromosome)

    {:ok, assign(socket, page_title: "N-Queens", settings: %{size: @default_size, population_size: @default_size * 10}, genes: chromosome.genes, conflicts: conflicts, statistics: nil)}
  end

  @impl true
  def handle_event("new-settings", params, socket) do
    size = String.to_integer(params["size"])
    population_size = String.to_integer(params["population_size"])

    chromosome = NQueens.genotype(%{size: size})
    conflicts  = NQueens.conflicts(chromosome)

    {:noreply, assign(socket, settings: %{size: size, population_size: population_size}, genes: chromosome.genes, conflicts: conflicts)}
  end

  @impl true
  def handle_event("solve", _params, socket) do
    population = Genetic.initialise(NQueens,
      population_size: socket.assigns.settings.population_size,
      problem_size: socket.assigns.settings.size
    )
    Genetic.Reporters.PubSubReporter.subscribe(population)

    {:ok, pid} = Task.Supervisor.start_child(Evolution.Genetic.TaskSupervisor, fn ->
      Genetic.solve(NQueens, population, reporter: Genetic.Reporters.PubSubReporter)
    end)

    {:noreply, assign(socket, population_id: population.id, pid: pid)}
  end

  @impl true
  def handle_event("stop", _params, socket) do
    Task.Supervisor.terminate_child(Evolution.Genetic.TaskSupervisor, socket.assigns.pid)
    {:noreply, assign(socket, pid: nil, statistics: nil)}
  end

  @impl true
  def handle_info({:new_generation, %{generation: generation, champion: nil}}, socket) do
    {:noreply, assign(socket, statistics: %{generation: generation, fitness: 0})}
  end

  @impl true
  def handle_info({:new_generation, %{generation: generation, champion: %{fitness: fitness}}}, socket) do
    {:noreply, assign(socket, statistics: %{generation: generation, fitness: fitness})}
  end

  @impl true
  def handle_info({:new_champion, %{champion: champion}}, socket) do
    Logger.info fn -> "A new champion has been found #{champion.fitness} for #{socket.assigns.population_id}" end
    {:noreply, assign(socket, genes: champion.genes, conflicts: NQueens.conflicts(champion))}
  end

  @impl true
  def handle_info({:solution_found, %{champion: champion}}, socket) do
    Logger.info fn -> "Solution found #{socket.assigns.population_id}" end

    Genetic.Reporters.PubSubReporter.unsubscribe(%{id: socket.assigns.population_id})
    {:noreply, assign(socket, genes: champion.genes, conflicts: [], statistics: nil)}
  end

  defp background_class(row, column), do: Integer.mod(row + column, 2) |> background_class()
  defp background_class(0), do: "bg-gray-300"
  defp background_class(1), do: "bg-white"
end
