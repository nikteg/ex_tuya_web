defmodule ExTuyaWebWeb.ButtonComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <a class="ButtonComponent" href="/<%= @device.id %>"><%= @device.id %></a>
    """
  end
end
