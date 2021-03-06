defmodule EvolutionWeb.Genetic.TravelingSalesmanLive do
  use EvolutionWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Traveling Salesman")}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      Traveling Salesman
    </div>
    """
  end
end
