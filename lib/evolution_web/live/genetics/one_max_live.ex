defmodule EvolutionWeb.Genetics.OneMaxLive do
  use EvolutionWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "One Max")}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      One Max
    </div>
    """
  end
end
