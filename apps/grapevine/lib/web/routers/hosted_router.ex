defmodule Web.HostedRouter do
  @moduledoc """
  Router for hosted sites
  """

  use Web, :router

  pipeline :browser do
    plug(:accepts, ["html", "json"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(Phoenix.LiveView.Flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Web.Plugs.FetchUser)
    plug(Web.Plugs.SessionToken)
  end

  scope "/", Web.Hosted do
    pipe_through([:browser])

    get("/", PageController, :index)

    get("/client", PlayController, :show)
  end
end
