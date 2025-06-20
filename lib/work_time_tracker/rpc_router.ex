defmodule WorkTimeTracker.RpcRouter do
  @moduledoc """
  Routes incoming RPC requests.

  It takes a method (the routing key) and a request body,
  then calls the appropriate function in the corresponding context module.
  """

  alias WorkTimeTracker.CardController
  # alias TimeTracker.WorkTime

  def route("/card/assign" = method, params) when is_map(params) do
    CardController.card_assign(method, params)
  end

  def route("/card/touch" = method, params) when is_map(params) do
    CardController.card_touch(method, params)
  end

  def route("/card/delete" = method, params) when is_map(params) do
    CardController.card_delete(method, params)
  end

  def route("/card/list_by_user" = method, params) when is_map(params) do
    CardController.card_list_by_user(method, params)
  end

  def route("/card/delete_all_by_user" = method, params) when is_map(params) do
    CardController.card_delete_all_by_user(method, params)
  end

  def route(method, params) when is_map(params), do: %{error: "The method #{method} does not exist"}

  def route(_method, _params), do: %{error: "Type Error. Params type must be map"}
end
