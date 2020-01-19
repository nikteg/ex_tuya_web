defmodule ExTuyaWebWeb.ChartComponent do
  use Phoenix.LiveComponent

  use Phoenix.HTML

  def render(assigns) do
    ~L"""
    <div class="ChartComponent">
      <%= f = form_for @changeset, "#", [phx_change: :update_device] %>
        <b><%= input_value f, :name %></b>
        <%= label f, :brightness %>
        <%= range_input f, :brightness, [phx_throttle: 500] %>
        <%= label f, :color %>
        <%= color_input f, :color %>
      </form>
    </div>
    """
  end
end
