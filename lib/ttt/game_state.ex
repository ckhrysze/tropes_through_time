defmodule Ttt.GameState do
  defstruct roles: nil, leaderboard: nil, plot_card: nil

  use GenServer

  @impl true
  def init(_) do
    state = %Ttt.GameState{
      roles: %{
        gm: nil,
        players: [],
        observers: []
      }
    }

    {:ok, state}
  end

  @impl true
  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def get_roles, do: GenServer.call(__MODULE__, :roles)
  def assign_gm(id), do: GenServer.call(__MODULE__, {:assign_gm, id})
  def add_observer(id), do: GenServer.call(__MODULE__, {:add_observer, id})
  def get_player(id), do: GenServer.call(__MODULE__, {:get_player, id})
  def get_players, do: GenServer.call(__MODULE__, :get_players)
  def start_next_round, do: GenServer.call(__MODULE__, :next_round)
  def get_plot_card, do: GenServer.call(__MODULE__, :plot_card)
  def update_player_score(id, score), do: GenServer.call(__MODULE__, {:update_score, id, score})
  def toggle_played(id, title), do: GenServer.call(__MODULE__, {:toggle_played, id, title})
  def get_leaderboard, do: GenServer.call(__MODULE__, :leaderboard)

  def add_player(id, name) do
    player = %Ttt.Player{id: id, name: name}
    GenServer.call(__MODULE__, {:add_player, player})
  end

  def hand_for(id) do
    get_player(id)
    |> case do
      nil -> []
      player -> player |> Map.get(:cards, [])
    end
  end

  #######################################
  #
  # GenServer handlers
  #
  #######################################

  def handle_call(:leaderboard, _from, state) do
    leaderboard =
      state.roles.players
      |> Enum.sort(fn a, b -> a.slot > b.slot end)
      |> Enum.into([], fn player ->
        {player.id, player.name, player.score}
      end)

    {:reply, leaderboard, state}
  end

  def handle_call({:toggle_played, id, title}, _from, state) do
    IO.puts("Handle call for toggle_played: #{title}")

    {[player], players} =
      state.roles.players
      |> Enum.split_with(fn p -> p.id == id end)

    hand =
      player.cards
      |> Enum.into([], fn card ->
        card.title
        |> IO.inspect()
        |> case do
          ^title -> Map.put(card, :played, !card.played)
          _ -> card
        end
      end)

    player = Map.put(player, :cards, hand)
    state = put_in(state.roles.players, [player | players])
    Phoenix.PubSub.broadcast(Ttt.PubSub, "game-events", :players)
    {:reply, :ok, state}
  end

  def handle_call({:update_score, id, score}, _from, state) do
    IO.puts("Handle call for update_score")

    {[player], players} =
      state.roles.players
      |> Enum.split_with(fn p -> p.id == id end)

    player = Map.put(player, :score, player.score + score)
    state = put_in(state.roles.players, [player | players])
    Phoenix.PubSub.broadcast(Ttt.PubSub, "game-events", :leaderboard)
    {:reply, :ok, state}
  end

  def handle_call(:roles, _from, %{roles: roles} = state), do: {:reply, roles, state}

  def handle_call({:assign_gm, id}, _from, state) do
    state = %Ttt.GameState{
      roles: %{
        gm: id,
        players: [],
        observers: []
      }
    }

    Phoenix.PubSub.broadcast(Ttt.PubSub, "game-events", :players)

    {:reply, :ok, state}
  end

  def handle_call({:add_player, player}, _from, state) do
    players = state.roles.players
    player = Map.put(player, :slot, Enum.count(players) + 1)

    if Enum.count(players) < 4 do
      players = [player | players]
      state = put_in(state.roles.players, players)
      Phoenix.PubSub.broadcast(Ttt.PubSub, "game-events", :players)
      {:reply, :ok, state}
    else
      {:reply, :error, state}
    end
  end

  def handle_call({:add_observer, id}, _from, state) do
    observers = state.roles.observers
    observers = [id | observers]
    state = put_in(state.roles.observers, observers)
    {:reply, :ok, state}
  end

  def handle_call({:get_player, id}, _from, state) do
    player =
      state.roles.players
      |> Enum.find(fn player -> player.id == id end)

    {:reply, player, state}
  end

  def handle_call(:get_players, _from, state), do: {:reply, state.roles.players, state}
  def handle_call(:plot_card, _from, state), do: {:reply, state.plot_card, state}

  def handle_call(:next_round, _from, state) do
    state =
      state
      |> pick_random_plot_card()
      |> assign_random_hands()

    Phoenix.PubSub.broadcast(Ttt.PubSub, "game-events", :new_round)
    {:reply, :ok, state}
  end

  #######################################
  #
  # Internal helper functions
  #
  #######################################

  def pick_random_plot_card(state) do
    card = Ttt.Decks.random_plot_card()
    Map.put(state, :plot_card, card)
  end

  def assign_random_hands(%{roles: %{players: players}} = state) do
    players =
      players
      |> Enum.map(&random_hand/1)

    put_in(state.roles.players, players)
  end

  def random_hand(player) do
    cards = Ttt.Decks.random_hand()

    Map.put(player, :cards, cards)
  end
end
