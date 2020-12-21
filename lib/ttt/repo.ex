defmodule Ttt.Repo do
  use Ecto.Repo,
    otp_app: :ttt,
    adapter: Ecto.Adapters.Postgres
end
