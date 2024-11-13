defmodule Armazedom.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ArmazedomWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:armazedom, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Armazedom.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Armazedom.Finch},
      # Start a worker by calling: Armazedom.Worker.start_link(arg)
      # {Armazedom.Worker, arg},
      # Start to serve requests, typically the last entry
      ArmazedomWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Armazedom.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ArmazedomWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
