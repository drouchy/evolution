defmodule EvolutionWeb.Genetic.Components.SolveButton do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
      <%= if @running do %>
        <button class="rounded inline-flex items-center px-8 py-2 rounded-full border border-red-600 text-red-600 max-w-max shadow-sm hover:shadow-lg">
          <span><i class="far fa-stop-circle"></i>&nbsp;Stop</span>
        </button>
      <% else %>
        <button class="rounded inline-flex items-center px-8 py-2 rounded-full border border-blue-600 text-blue-600 max-w-max shadow-sm hover:shadow-lg">
          <span><i class="fas fa-search"></i>&nbsp;Solve</span>
        </button>
      <% end %>
    """
  end
end
