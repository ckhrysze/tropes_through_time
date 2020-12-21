defmodule TttWeb.PageLive do
  use TttWeb, :live_view

  def get_player(id), do: Ttt.GameState.get_player(id)

  def get_player_at(slot) do
    Ttt.GameState.get_players()
    |> Enum.find(fn p ->
      p.slot == slot
    end)
  end

  def mount(_params, _session, socket) do
    IO.inspect("mount called")

    Phoenix.PubSub.subscribe(Ttt.PubSub, "game-events")

    assigns = assign(socket, :id, Ecto.UUID.generate())

    {:ok,
     assign(socket,
       id: Ecto.UUID.generate(),
       hand: [],
       role: nil,
       roles: Ttt.GameState.get_roles(),
       temp_role: "observer",
       player1: nil,
       player2: nil,
       player3: nil,
       player4: nil,
       plot_card: Ttt.GameState.get_plot_card(),
       leaderboard: [],
       name_capture: false,
       show_board: false
     )}
  end

  # handle events, so phx liveview handlers

  def handle_event("role-update", %{"role" => role}, socket) do
    IO.puts("Role update: " <> role)
    socket = assign(socket, :temp_role, role)

    String.equivalent?(role, "player")
    |> case do
      true -> assign(socket, :name_capture, true)
      false -> assign(socket, :name_capture, false)
    end
    |> noreply()
  end

  def handle_event("role-submit", %{"role" => role} = data, socket) do
    case role do
      "player" ->
        Ttt.GameState.add_player(socket.assigns.id, Map.get(data, "name", "Unknown"))

      "observer" ->
        Ttt.GameState.add_observer(socket.assigns.id)

      "gm" ->
        Ttt.GameState.assign_gm(socket.assigns.id)
    end

    assign(socket, :role, role)
    |> noreply
  end

  def handle_event("next-round", _data, socket) do
    Ttt.GameState.start_next_round()
    {:noreply, socket}
  end

  def handle_event("show-leaderboard", _data, socket) do
    socket
    |> assign(:leaderboard, Ttt.GameState.get_leaderboard())
    |> assign(:show_board, true)
    |> noreply()
  end

  def handle_event("close-leaderboard", _data, socket) do
    {:noreply, assign(socket, :show_board, false)}
  end

  def handle_event("decrease-score", %{"player" => player_id}, socket) do
    Ttt.GameState.update_player_score(player_id, -50)
    {:noreply, socket}
  end

  def handle_event("increase-score", %{"player" => player_id}, socket) do
    Ttt.GameState.update_player_score(player_id, 50)
    {:noreply, socket}
  end

  def handle_event("toggle-card", %{"title" => title}, socket) do
    Ttt.GameState.toggle_played(socket.assigns.id, title)

    {:noreply, socket}
  end

  def handle_event(event_name, data, socket) do
    IO.puts("Unknown event")
    IO.inspect(event_name)
    IO.inspect(data)

    {:noreply, socket}
  end

  # handle info, so basicaly pubsub

  def handle_info(:players, socket) do
    IO.puts("handle info for player update")

    socket
    |> assign_players(Ttt.GameState.get_players())
    |> assign(:hand, Ttt.GameState.hand_for(socket.assigns.id))
    |> noreply
  end

  def handle_info(:new_round, socket) do
    IO.puts("handle info for new round")

    socket
    |> assign_players(Ttt.GameState.get_players())
    |> assign(:plot_card, Ttt.GameState.get_plot_card())
    |> assign(:hand, Ttt.GameState.hand_for(socket.assigns.id))
    |> noreply()
  end

  def handle_info(:leaderboard, socket) do
    IO.puts("Leaderboard update")

    socket
    |> assign(:leaderboard, Ttt.GameState.get_leaderboard())
    |> noreply()
  end

  def handle_info(one, socket) do
    IO.puts("Handle info")
    IO.inspect(one)

    {:noreply, socket}
  end

  # misc functions

  def assign_players(socket, []), do: socket

  def assign_players(socket, [%{slot: 1} = player | players]) do
    assign(socket, :player1, player)
    |> assign_players(players)
  end

  def assign_players(socket, [%{slot: 2} = player | players]) do
    assign(socket, :player2, player)
    |> assign_players(players)
  end

  def assign_players(socket, [%{slot: 3} = player | players]) do
    assign(socket, :player3, player)
    |> assign_players(players)
  end

  def assign_players(socket, [%{slot: 4} = player | players]) do
    assign(socket, :player4, player)
    |> assign_players(players)
  end

  def noreply(socket), do: {:noreply, socket}
end
