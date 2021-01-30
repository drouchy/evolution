defmodule Evolution.Utils.FakeRandom do
  @behaviour Evolution.Utils.Random

  def new([values: values]) do
    {:ok, agent} = Agent.start_link fn -> values end
    fn (_) ->
      Agent.get_and_update(agent, fn [next | rest] -> {next, rest} end)
    end
  end
end
