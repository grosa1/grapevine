defmodule Web.GameView do
  use Web, :view

  alias Gossip.Games
  alias Web.ConnectionView

  def render("index.json", %{games: games}) do
    %{
      collection: render_many(games, __MODULE__, "show.json"),
    }
  end

  def render("show.json", %{game: game}) do
    %{
      game: Map.take(game.game, [:name, :homepage_url]),
      players: game.players,
    }
  end

  def render("status.json", %{game: game}) do
    json = %{game: game.short_name, display_name: game.name}

    json
    |> maybe_add(:description, game.description)
    |> maybe_add(:homepage_url, game.homepage_url)
    |> maybe_add(:user_agent, game.user_agent)
    |> maybe_add(:user_agent_url, user_agent_repo_url(game.user_agent))
    |> maybe_add_connections(game)
  end

  defp maybe_add_connections(json, game) do
    case game.connections do
      [] ->
        json

      connections ->
        connections =
          connections
          |> Enum.map(fn connection ->
            ConnectionView.render("show.json", %{connection: connection})
          end)

        Map.put(json, :connections, connections)
    end
  end

  defp user_agent_repo_url(nil), do: nil

  defp user_agent_repo_url(user_agent) do
    with {:ok, user_agent} <- Games.get_user_agent(user_agent),
         {:ok, user_agent} <- check_if_repo_url(user_agent) do
      user_agent.repo_url
    else
      _ ->
        nil
    end
  end

  defp maybe_add(json, _field, nil), do: json

  defp maybe_add(json, field, value) do
    Map.put(json, field, value)
  end

  def user_agent(game) do
    case game.user_agent do
      nil ->
        nil

      user_agent ->
        display_user_agent(user_agent)
    end
  end

  defp display_user_agent(user_agent) do
    with {:ok, user_agent} <- Games.get_user_agent(user_agent),
         {:ok, user_agent} <- check_if_repo_url(user_agent) do
      link(user_agent.version, to: user_agent.repo_url, target: "_blank")
    else
      {:error, :no_repo_url, user_agent} ->
        user_agent.version

      _ ->
        nil
    end
  end

  defp check_if_repo_url(user_agent) do
    case user_agent.repo_url do
      nil ->
        {:error, :no_repo_url, user_agent}

      _ ->
        {:ok, user_agent}
    end
  end
end
