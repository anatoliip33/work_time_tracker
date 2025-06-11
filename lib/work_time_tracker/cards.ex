defmodule WorkTimeTracker.Cards do
  @moduledoc """
  Manages the business logic for NFC cards.
  """

  import Ecto.Query, warn: false
  import WorkTimeTracker.Helper, only: [format_errors: 1]

  alias WorkTimeTracker.Repo
  alias WorkTimeTracker.Cards.Card

  def card_assign(params) do
    %Card{}
    |> Card.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, card} ->
        %{card_uid: card.card_uid, user_id: card.user_id}

      {:error, changeset} ->
        %{error: format_errors(changeset)}
    end
  end

  def card_touch(card_uid) do
    query_card_by_uid(card_uid)
    |> select([card], %{card_uid: card.card_uid, user_id: card.user_id})
    |> Repo.one()
  end

  def card_delete(card_uid) do
    query_card_by_uid(card_uid)
    |> Repo.one()
    |> case do
      %Card{card_uid: card_uid, user_id: user_id} = card ->
        Repo.delete(card)
        %{card_uid: card_uid, user_id: user_id}

      _ ->
        nil
    end
  end

  def get_cards_by_user(user_id) do
    card_uids =
      Repo.all(
        query_cards_by_user(user_id)
        |> select([card], card.card_uid)
      )

    %{user_id: card_uids}
  end

  def delete_cards_by_user(user_id) do
    get_cards_by_user(user_id)
    |> case do
      %{user_id: []} ->
        nil

      %{user_id: card_uids} ->
        Repo.delete_all(query_cards_by_user(user_id))
        %{user_id: card_uids}
    end
  end

  defp query_card_by_uid(card_uid) do
    from(c in Card, where: c.card_uid == ^card_uid)
  end

  defp query_cards_by_user(user_id) do
    from(c in Card, where: c.user_id == ^user_id)
  end
end
