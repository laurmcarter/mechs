defmodule Mechs.Repo do
  use Ecto.Repo,
    otp_app: :mechs,
    adapter: Ecto.Adapters.Postgres
end
