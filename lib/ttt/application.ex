defmodule Ttt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Ttt.GameState,
      Ttt.Repo,
      TttWeb.Telemetry,
      {Phoenix.PubSub, name: Ttt.PubSub},
      TttWeb.Endpoint
      # Start a worker by calling: Ttt.Worker.start_link(arg)
      # {Ttt.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ttt.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TttWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
