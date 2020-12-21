defmodule Ttt.Decks do
  alias Ttt.Card

  def random_plot_card do
    plot_deck
    |> Enum.random()
  end

  def random_hand() do
    ccards =
      character_deck()
      |> Enum.shuffle()
      |> Enum.take(4)

    mcards =
      modifier_deck()
      |> Enum.shuffle()
      |> Enum.take(6)

    ccards ++ mcards
  end

  def plot_deck do
    [
      %Card{
        title: "Alien Invasion",
        genres: ["sci-fi", "modern"],
        cast: ["4 hero lead", "1 villian lead", "3 hero support", "2 extra"],
        type: :plot
      },
      %Card{
        title: "Alternate Universe",
        genres: ["sci-fi", "modern", "fantasy"],
        cast: ["3 hero lead", "2 villian lead", "2 hero support", "3 villian support"],
        type: :plot
      },
      %Card{
        title: "The Big Race",
        genres: ["sci-fi", "modern"],
        cast: ["4 hero lead", "4 villian lead", "2 extra"],
        type: :plot
      },
      %Card{
        title: "Body Count Competition",
        genres: ["sci-fi", "fantasy"],
        cast: ["4 hero lead", "1 villian lead", "2 villian support", "3 extra"],
        type: :plot
      },
      %Card{
        title: "Breaking Out the Boss",
        genres: ["sci-fi", "modern", "fantasy"],
        cast: ["1 hero lead", "2 hero support", "4 villian lead", "3 villian support"],
        type: :plot
      },
      %Card{
        title: "Bring Back Help",
        genres: ["modern", "fantasy"],
        cast: ["1 hero lead", "2 hero support", "2 villian lead", "2 villian support", "3 extra"],
        type: :plot
      }
    ]
  end

  def character_deck do
    [
      %Card{
        type: :character,
        title: "the black knight",
        cast: ["villian lead", "villian support", "extra"],
        genres: ["sci-fi", "fantasy"]
      },
      %Card{
        type: :character,
        title: "noble demon",
        cast: ["villian lead, villian support, extra"],
        genres: ["modern, fantasy"]
      },
      %Card{
        type: :character,
        title: "the dragon",
        cast: ["villian lead"],
        genres: ["sci-fi", "fantasy"],
        rules: "can't be the first villian lead played, worth double ratings"
      },
      %Card{
        type: :character,
        title: "big bad",
        cast: ["villian lead"],
        genres: ["sci-fi", "modern", "fantasy"],
        rules: "if first villian played this round, you may cast another character"
      },
      %Card{
        type: :character,
        title: "wandering minstrel",
        cast: ["hero support, villian support, extra"],
        genres: ["modern", "fantasy"]
      },
      %Card{
        type: :character,
        title: "the storyteller",
        cast: ["hero support, villian support, extra"],
        genres: ["sci-fi", "modern", "fantasy"]
      },
      %Card{
        type: :character,
        title: "the bard",
        cast: ["hero support, villian support, extra"],
        genres: ["modern", "fantasy"]
      },
      %Card{
        type: :character,
        title: "byronic hero",
        cast: ["hero lead, villian lead"],
        genres: ["sci-fi", "modern", "fantasy"]
      },
      %Card{
        type: :character,
        title: "camp cook",
        cast: ["hero support, extra"],
        genres: ["sci-fi", "modern", "fantasy"]
      },
      %Card{
        type: :character,
        title: "cowboy cop",
        cast: ["hero lead"],
        genres: ["sci-fi", "modern", "fantasy"]
      },
      %Card{
        type: :character,
        title: "da chief",
        cast: ["hero support"],
        genres: ["sci-fi", "modern", "fantasy"]
      },
      %Card{
        type: :character,
        title: "retired gunfighter",
        cast: ["hero lead", "hero support"],
        genres: ["sci-fi", "modern"]
      },
      %Card{
        type: :character,
        title: "old master",
        cast: ["hero lead", "hero support"],
        genres: ["sci-fi", "fantasy"]
      },
      %Card{
        type: :character,
        title: "lovable rogue",
        cast: ["hero lead, villian lead, hero support, villian support"],
        genres: ["sci-fi", "modern", "fantasy"]
      },
      %Card{
        type: :character,
        title: "inept mage",
        cast: ["hero support, extra"],
        genres: ["sci-fi", "fantasy"]
      },
      %Card{
        type: :character,
        title: "the drifter",
        cast: ["hero lead, extra"],
        genres: ["sci-fi", "modern", "fantasy"]
      },
      %Card{
        type: :character,
        title: "giant mook",
        cast: ["extra"],
        genres: ["sci-fi", "modern", "fantasy"],
        rules: "At the end of the round, earns ratings equal to the highest uncast villian role"
      },
      %Card{
        type: :character,
        title: "almighty janitor",
        cast: ["extra"],
        genres: ["sci-fi", "modern", "fantasy"],
        rules: "At the end of the round, earns ratings equal to the highest uncast hero role"
      }
    ]
  end

  def modifier_deck do
    [
      %Card{type: :modifier, title: "lampshaded", rules: "cancel the effects of another motif"},
      %Card{type: :modifier, title: "back in my day", rules: "copy a modifier card in play"},
      %Card{type: :modifier, title: "plot armor", rules: "make 1 character immune to motifs"},
      %Card{type: :modifier, title: "the cavalry", rules: "cast another hero support"},
      %Card{
        type: :modifier,
        title: "anyone can die",
        rules: "half the ratings for all support characters and extras this round"
      },
      %Card{
        type: :modifier,
        title: "the cake is a lie",
        rules: "half the ratings for all hero characters this round"
      },
      %Card{
        type: :modifier,
        title: "macguffin",
        rules: "re-target an already played motif"
      },
      %Card{
        type: :modifier,
        title: "let's get dangerous!",
        rules: "double the ratings for all hero supports this round"
      },
      %Card{
        type: :modifier,
        title: "achilles heel",
        rules: "make 1 lead an extra this round"
      },
      %Card{
        type: :modifier,
        title: "department of redundancy department",
        rules: "double the ratings for 1 support character or extra this round"
      },
      %Card{
        type: :modifier,
        title: "rule of drama",
        rules: "anyone with a lead character cast may cast a support character"
      },
      %Card{
        type: :modifier,
        title: "just between you and me",
        rules: "double the ratings for 1 villian lead"
      },
      %Card{
        type: :modifier,
        title: "weak, but skilled",
        rules: "double the ratings for 1 hero lead"
      },
      %Card{
        type: :modifier,
        title: "feet of clay",
        rules: "half the ratings for 1 villian lead"
      },
      %Card{
        type: :modifier,
        title: "miles gloriosus",
        rules: "half the ratings for 1 hero lead"
      },
      %Card{
        type: :modifier,
        title: "temporary blindness",
        rules: "half the ratings for 1 hero lead, double the rating for 1 hero support"
      },
      %Card{
        type: :modifier,
        title: "malicious slander",
        rules: "half the ratings for 1 hero lead, double the rating for 1 villian support"
      },
      %Card{
        type: :modifier,
        title: "boisterous weakling",
        rules: "half the ratings for 1 villian lead, double the rating for 1 hero support"
      },
      %Card{
        type: :modifier,
        title: "crouching moron, hidden badass",
        rules: "upgrade a hero support to hero lead"
      },
      %Card{
        type: :modifier,
        title: "jumping the shark",
        rules: "all leads become extras this round"
      },
      %Card{
        type: :modifier,
        title: "growing the beard",
        rules: "double the ratings for all leads this round"
      }
    ]
  end
end
