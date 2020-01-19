defmodule ExTuyaWebWeb.PageLive do
  use Phoenix.LiveView
  alias ExTuyaWebWeb.Device
  import Ecto.Changeset

  def render(assigns) do
    Phoenix.View.render(ExTuyaWebWeb.PageView, "index.html", assigns)
  end

  def mount(_session, socket) do
    if connected?(socket) do
      send(self(), :login)
    end

    {:ok,
     assign(socket,
       devices: [],
       changeset: nil
     )}
  end

  def handle_info(:login, socket) do
    IO.inspect(socket.assigns, label: "In login handle")

    {:ok, %{"access_token" => access_token}} =
      ExTuya.login(%ExTuya.Credentials{
        userName: Application.fetch_env!(:ex_tuya, :username),
        password: Application.fetch_env!(:ex_tuya, :password),
        countryCode: "46",
        bizType: "tuya"
      })

    {:ok, devices} = ExTuya.get_devices(access_token) |> IO.inspect(label: "get devices")

    devices_changesets =
      Enum.map(devices, fn d ->
        %{"brightness" => brightness} = d["data"]

        cast(
          %ExTuyaWeb.Device{},
          %{
            id: d["id"],
            icon: d["icon"],
            name: d["name"],
            dev_type: d["dev_type"],
            ha_type: d["ha_type"],
            brightness: brightness
          },
          [:id, :name, :dev_type, :ha_type, :brightness, :icon]
        )
      end)

    devices =
      Enum.map(devices_changesets, fn cs ->
        {:ok, device} = apply_action(cs, :insert)
        device
      end)
      |> IO.inspect(label: "devices")

    {:noreply,
     assign(socket,
       access_token: access_token,
       devices: devices,
       changeset: hd(devices_changesets)
     )}
  end

  def handle_event("update_device", %{"device" => params}, socket) do
    changeset = cast(socket.assigns.changeset, params, [:brightness, :color])

    {:ok, device} = apply_action(changeset, :update)

    ExTuya.Light.set_brightness(socket.assigns.access_token, device.id, device.brightness)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_params(%{"device_id" => device_id} = _params, _uri, socket) do
    {:noreply, put_device(socket, device_id)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp put_device(socket, device_id) do
    assign(socket, device: Enum.find(socket.assigns.devices, fn d -> d.id == device_id end))
  end
end
