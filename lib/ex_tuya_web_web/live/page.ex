defmodule ExTuyaWebWeb.Device do
  defstruct [:id, :brightness, color: "#000000"]
end

defmodule ExTuyaWebWeb.PageLive do
  use Phoenix.LiveView
  alias ExTuyaWebWeb.Device

  def render(assigns) do
    Phoenix.View.render(ExTuyaWebWeb.PageView, "index.html", assigns)
  end

  def mount(_session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    # Device.changeset(device, attrs)

    devices = [
      %Device{id: "test-id", brightness: 50, color: "#ff0000"},
      %Device{id: "test-id-2", brightness: 70}
    ]

    {:ok, assign(put_date(socket), devices: devices, device: hd(devices))}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_date(socket)}
  end

  def handle_event("nav", path, socket) do
    IO.inspect(path, label: "Nav")
    {:noreply, socket}
  end

  def handle_event("update_device", %{"device"}, socket) do
    IO.inspect(value)

    {:noreply, socket}
  end

  def handle_params(%{"device_id" => device_id} = _params, _uri, socket) do
    {:noreply, put_device(socket, device_id)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp put_date(socket) do
    assign(socket, time: DateTime.utc_now())
  end

  defp put_device(socket, device_id) do
    assign(socket, device: Enum.find(socket.assigns.devices, fn d -> d.id == device_id end))
  end
end

defimpl Phoenix.HTML.FormData, for: ExTuyaWebWeb.Device do
  def input_value(device, %{data: data, params: params}, field) do
    Map.fetch!(device, field)
  end

  def input_validations(device, form, field), do: []

  def input_type(device, form, :brightness), do: "range"
  def input_type(device, form, field), do: :text_input

  def to_form(device, opts) do
    {params, opts} = Keyword.pop(opts, :params, %{})

    %Phoenix.HTML.Form{
      source: device,
      impl: __MODULE__,
      id: device.id,
      name: "device",
      params: params,
      data: %{},
      errors: [],
      options: opts
    }
  end

  def to_form(device, form, field, options) do
  end
end
