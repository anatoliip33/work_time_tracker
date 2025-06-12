defmodule WorkTimeTracker.CardController do
  @moduledoc """
  Handles RPC requests related to NFC Cards.
  It validates incoming parameters and extract data from Cards context.
  """
  import WorkTimeTracker.Helper, only: [format_errors: 1]
  alias WorkTimeTracker.Cards

  @types %{
    user_id: :integer,
    card_uid: Ecto.UUID
  }

  def card_assign(_method, params) do
    with {:ok, card} <- Cards.add(params) do
      %{card_uid: card.card_uid, user_id: card.user_id}
    else
      {:error, changeset} ->
        %{error: format_errors(changeset)}
    end
  end

  def card_touch(method, params) do
    with {:ok, valid_params} <- validation(method, params) do
      Cards.get(valid_params["card_uid"])
    end
  end

  def card_delete(method, params) do
    with {:ok, valid_params} <- validation(method, params),
         %{card_uid: card_uid, user_id: user_id} <- Cards.get(valid_params["card_uid"]),
         {_, nil} <- Cards.delete(valid_params["card_uid"]) do
      %{card_uid: card_uid, user_id: user_id}
    end
  end

  def card_list_by_user(method, params) do
    with {:ok, valid_params} <- validation(method, params) do
      %{user_id: Cards.get_cards_by_user(valid_params["user_id"])}
    end
  end

  def card_delete_all_by_user(method, params) do
    with {:ok, valid_params} <- validation(method, params),
         [_ | _] = cards <- Cards.get_cards_by_user(valid_params["user_id"]),
         {_, nil} <- Cards.delete_cards_by_user(valid_params["user_id"]) do
      %{user_id: cards}
    else
      [] ->
        %{user_id: []}
        
      error ->
        error
    end
  end

  def validation(method, params) do
    fields = method_specs(method)

    {%{}, fields}
    |> Ecto.Changeset.cast(params, Map.keys(fields))
    |> Ecto.Changeset.validate_required(Map.keys(fields))
    |> case do
      %Ecto.Changeset{valid?: true} ->
        {:ok, params}

      changeset ->
        format_errors(changeset)
    end
  end

  defp method_specs("/card/touch"), do: @types |> Map.take([:card_uid])
  defp method_specs("/card/delete"), do: @types |> Map.take([:card_uid])
  defp method_specs("/card/list_by_user"), do: @types |> Map.take([:user_id])
  defp method_specs("/card/delete_all_by_user"), do: @types |> Map.take([:user_id])
end
