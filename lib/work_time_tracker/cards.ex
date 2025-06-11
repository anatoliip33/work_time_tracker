defmodule WorkTimeTracker.Cards do
  @moduledoc """
  Manages the business logic for NFC cards.
  """

  import Ecto.Query, warn: false

  alias WorkTimeTracker.Repo
  alias WorkTimeTracker.Cards.Card

  def add(params) do
    %Card{}
    |> Card.changeset(params)
    |> Repo.insert()
  end

  def get(card_uid) do
    from(c in Card, where: c.card_uid == ^card_uid)
    |> select([card], %{card_uid: card.card_uid, user_id: card.user_id})
    |> Repo.one()
  end

  def delete(card_uid) do
    from(c in Card, where: c.card_uid == ^card_uid)
    |> Repo.delete_all()
  end

  def get_cards_by_user(user_id) do
    Repo.all(
      query_for_cards(user_id)
      |> select([card], card.card_uid)
    )
  end

  def delete_cards_by_user(user_id) do
    query_for_cards(user_id)
    |> Repo.delete_all()
  end

  defp query_for_cards(user_id) do
    from(c in Card, where: c.user_id == ^user_id)
  end
end
