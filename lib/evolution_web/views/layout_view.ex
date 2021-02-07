defmodule EvolutionWeb.LayoutView do
  use EvolutionWeb, :view

  def navigation_item_link_class(conn, path, :full) do
    case sub_path?(conn.request_path, path) do
      true  -> "px-3 py-2 rounded-md text-sm font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700 active-menu-item"
      false -> "px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700"
    end
  end

  def navigation_item_link_class(conn, path, :compact) do
    case String.starts_with?(conn.request_path, path) do
      true  -> "block px-3 py-2 rounded-md text-base font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700 "
      false -> "block px-3 py-2 rounded-md text-base font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700"
    end
  end

  def navigation_menu_class(:full), do: "ml-10 flex items-baseline space-x-4"
  def navigation_menu_class(:compact), do: "px-2 pt-2 pb-3 space-y-1 sm:px-3"

  defp sub_path?("/", "/"), do: true
  defp sub_path?(_,   "/"), do: false
  defp sub_path?(request_path, path) do
    String.starts_with?(request_path, path)
  end
end
