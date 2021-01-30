defmodule Evolution.Genetic.Reporters.PubSubReporterTest do
  use ExUnit.Case, async: true

  alias Evolution.Genetic.Reporters.PubSubReporter, as: Reporter

  alias Evolution.Genetic.Population

  setup do
    population = %Population{chromosomes: Enum.to_list(1..8)}
    Reporter.subscribe(population)

    on_exit fn ->
      Reporter.unsubscribe(population)
    end

    {:ok, population: population}
  end

  test "new_generation/2 sends a PubSub message", %{population: population} do
    Reporter.new_generation(population, [])

    assert_received {:new_generation, ^population}
  end

  test "new_champion/2 sends a PubSub message", %{population: population} do
    Reporter.new_champion(population, [])

    assert_received {:new_champion, ^population}
  end

  test "solution_found/2 sends a PubSub message", %{population: population} do
    Reporter.solution_found(population, [])

    assert_received {:solution_found, ^population}
  end
end
