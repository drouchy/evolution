defmodule EvolutionWeb.Genetics.NQueensLive do
  use EvolutionWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "N-Queens")}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      N-Queens
    </div>
    """
  end
end
