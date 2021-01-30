defmodule EvolutionWeb.Genetics.KnapsackLive do
  use EvolutionWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Knapsack")}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      Knapsack
    </div>
    """
  end
end
