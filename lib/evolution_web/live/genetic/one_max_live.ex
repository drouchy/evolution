defmodule EvolutionWeb.Genetic.OneMaxLive do
  use EvolutionWeb, :live_view

  alias Evolution.Genetic
  alias Evolution.Genetic.Problems.OneMax

  require Logger

  @default_size 10

  @impl true
  def mount(_params, _session, socket) do
    chromosome = OneMax.genotype(%{size: @default_size})

    {:ok, assign(socket, page_title: "One Max", settings: %{size: @default_size, population_size: @default_size * 10}, genes: chromosome.genes, statistics: nil)}
  end

  @impl true
  def handle_event("new-settings", params, socket) do
    size = String.to_integer(params["size"])
    population_size = String.to_integer(params["population_size"])

    chromosome = OneMax.genotype(%{size: size})

    {:noreply, assign(socket, settings: %{size: size, population_size: population_size}, genes: chromosome.genes)}
  end

  @impl true
  def handle_event("solve", _params, socket) do
    population = Genetic.initialise(OneMax,
      population_size: socket.assigns.settings.population_size,
      problem_size: socket.assigns.settings.size
    )
    Evolution.Reporters.PubSubReporter.subscribe(population)

    Task.Supervisor.start_child(Evolution.Genetic.TaskSupervisor, fn ->
      Genetic.solve(OneMax, population, reporter: Evolution.Reporters.PubSubReporter)
    end)

    {:noreply, assign(socket, population_id: population.id)}
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
    {:noreply, assign(socket, genes: champion.genes)}
  end

  @impl true
  def handle_info({:solution_found, %{champion: champion}}, socket) do
    Logger.info fn -> "Solution found #{socket.assigns.population_id}" end

    Evolution.Reporters.PubSubReporter.unsubscribe(%{id: socket.assigns.population_id})
    {:noreply, assign(socket, genes: champion.genes, statistics: nil)}
  end

  defp gene_class(genes, i) do
    case Enum.at(genes, i) do
      0 -> "bg-yellow-500"
      1 -> "bg-green-500"
    end
  end
end
