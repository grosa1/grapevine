defmodule Web.ConnectionView do
  use Web, :view

  def render("show.json", %{connection: connection}) do
    case connection.type do
      "web" ->
        Map.take(connection, [:type, :url])

      "telnet" ->
        Map.take(connection, [:type, :host, :port])

      "secure telnet" ->
        Map.take(connection, [:type, :host, :port])
    end
  end
end
