defmodule Cards do
  @moduledoc """
  Documentation for Cards.
  """

  @doc """
  Returns a list of strings representing a deck of playing cards

  ## Examples

      iex> Cards.create_deck()
      ["As", "Ah", "Ac", "Ad", "2s", "2h", "2c", "2d", "3s", "3h", "3c", "3d", "4s", "4h", "4c", "4d",
      "5s", "5h", "5c", "5d", "6s", "6h", "6c", "6d", "7s", "7h", "7c", "7d", "8s", "8h", "8c", "8d",
      "9s", "9h", "9c", "9d", "10s", "10h", "10c", "10d", "Js", "Jh", "Jc", "Jd", "Qs", "Qh", "Qc", "Qd",
      "Ks", "Kh", "Kc", "Kd" ]

  """
  def create_deck do
    values = [
      "A",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "J",
      "Q",
      "K"
    ]

    suits = ["s", "h", "c", "d"]

    for value <- values, suit <- suits do
      "#{value}#{suit}"
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
  Determines whether the deck for a given card.

  ## Examples

      iex> deck = Cards.create_deck()
      iex> Cards.contains?(deck, "As")
      true

  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
  Divides a deck into a hand and the remainder of the deck.
  The `hand_size` argument indicates how many cards should be in the hand.

  ## Examples

      iex> deck = Cards.create_deck()
      iex> {hand, _deck} = Cards.deal(deck, 1)
      iex> hand
      ["As"]

  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  @spec save(
          any,
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | char,
              binary | []
            )
        ) :: :ok | {:error, atom}
  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _reason} -> "File does not exist"
    end
  end

  def create_hand(hand_size) do
    create_deck()
    |> shuffle
    |> deal(hand_size)
  end
end
