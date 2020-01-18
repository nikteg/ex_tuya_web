defmodule ExTuyaWebWeb.ChartComponent do
  use Phoenix.LiveComponent

  use Phoenix.HTML

  def render(assigns) do
    ~L"""
    <div class="ChartComponent">
      <%= f = form_for @changeset, "#", [phx_change: :update_device] %>
        <b><%= input_value f, :id %></b>
        <%= label f, :brightness %>
        <%= range_input f, :brightness %>
        <%= label f, :color %>
        <%= color_input f, :color %>
      </form>
    </div>
    """
  end
end
