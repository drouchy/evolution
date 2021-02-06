defmodule EvolutionWeb.Genetic.Components.Statistics do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
      <%= if @statistics do %>
        <h2>Generation: <%= @statistics.generation %></h2>
        Best overall: <%= @statistics.fitness %>
      <% end %>
    """
  end
end
