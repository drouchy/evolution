defmodule EvolutionWeb.Genetic.Components.Settings do
  use Phoenix.LiveComponent

  @impl true
  def render(assigns) do
    ~L"""
      <div class="w-full md:w-1/2 px-3 mb-6 md:mb-0">
        <label class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" for="grid-first-name">
          Size
        </label>
        <input class="rounded-lg overflow-hidden appearance-none bg-gray-400 h-3 w-128" type="range" min="<%= @min %>" max="<%= @max %>" step="1" value="<%= @settings.size %>" name="size"/>
        <p class="text-gray-600 text-xs italic"><%= @settings.size %></p>
      </div>
      <div class="w-full md:w-1/2 px-3">
        <label class="block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2" for="grid-last-name">
          Population size
        </label>
        <input class="rounded-lg overflow-hidden appearance-none bg-gray-400 h-3 w-128" type="range" min="10" max="300" step="10" value="<%= @settings.population_size %>" name="population_size"/>
          <p class="text-gray-600 text-xs italic"><%= @settings.population_size %></p>
      </div>
    """
  end
end
