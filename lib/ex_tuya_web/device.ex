defmodule ExTuyaWeb.Device do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:name, :string)
    field(:dev_type, :string)
    field(:ha_type, :string)
    field(:brightness, :integer)
    field(:icon, :string)
    field(:color, :string)
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:id, :name, :dev_type, :ha_type, :icon])

    # |> validate_required([:id, :brightness, :color])
  end
end
