defmodule Mechs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MechsWeb.Telemetry,
      # Start the Ecto repository
      Mechs.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Mechs.PubSub},
      # Start Finch
      {Finch, name: Mechs.Finch},
      # Start the Endpoint (http/https)
      MechsWeb.Endpoint,
      # Start a worker by calling: Mechs.Worker.start_link(arg)
      # {Mechs.Worker, arg}
      # {Plug.Cowboy, scheme: :http, plug: Mechs.GrpcServer, options: [port: 50051]}
      {GRPC.Server.Supervisor, strategy: :one_for_one, name: Mechs.GRPC.Supervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mechs.Supervisor]
    {:ok, sup} = Supervisor.start_link(children, opts)
    start_grpc_server(Mechs.GRPC.Supervisor)
    {:ok, sup}
  end

  defp start_grpc_server(supervisor) do
    spec = GRPC.Server.child_spec({Mechs.GreeterService, 50051, name: Mechs.GreeterService.Server})
    Supervisor.start_child(supervisor, spec)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MechsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
