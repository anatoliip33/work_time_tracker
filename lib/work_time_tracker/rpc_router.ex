defmodule WorkTimeTracker.RpcRouter do
  @moduledoc """
  Routes incoming RPC requests.

  It takes a method (the routing key) and a request body,
  then calls the appropriate function in the corresponding context module.
  """

  alias WorkTimeTracker.Cards
  # alias TimeTracker.WorkTime
  # import Logger, only: [warn: 1]

  def route("/card/assign", params) do
    Cards.card_assign(params)
  end

  def route("/card/touch", %{"card_uid" => card_uid}) do
    Cards.card_touch(card_uid)
  end

  def route("/card/delete", %{"card_uid" => card_uid}) do
    Cards.card_delete(card_uid)
  end

  def route("/card/list_by_user", %{"user_id" => user_id}) do
    Cards.get_cards_by_user(user_id)
  end

  def route("/card/delete_all_by_user", %{"user_id" => user_id}) do
    Cards.delete_cards_by_user(user_id)
  end

  def route(method, _params) do
    %{error: "The method #{method} does not exist"}
  end
end
