defmodule Evolution.Swarm.AntColony.Trip do
  @enforce_keys [:path, :fitness]
  defstruct [:path, :fitness]
end
