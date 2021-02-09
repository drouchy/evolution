defmodule Evolution.Swarm do
  @defaults [
    reporter: Evolution.Reporters.BlackHoleReporter
  ]

  def solve(problem, settings \\ []) do
    all_settings = @defaults
    |> Keyword.merge(problem.defaults())
    |> Keyword.merge(settings)

    all_settings[:reporter].init(settings)

    case all_settings[:using] do
      :ant_colony -> Evolution.Swarm.AntColony.solve(problem, all_settings)
    end
  end

end
