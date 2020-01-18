defmodule ExTuyaWeb.Repo do
  use Ecto.Repo,
    otp_app: :ex_tuya_web,
    adapter: Ecto.Adapters.Postgres
end
