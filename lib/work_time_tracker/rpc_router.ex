defmodule WorkTimeTracker.RpcRouter do
  @moduledoc """
  Routes incoming RPC requests.

  It takes a method (the routing key) and a request body,
  then calls the appropriate function in the corresponding context module.
  """

  # alias WorkTimeTracker.Cards
  # alias TimeTracker.WorkTime
  # import Logger, only: [warn: 1]

  def route("/card/touch", %{"card_uid" => card_uid}) do
    # Cards.touch(card_uid)

    %{card_uid: card_uid, user_id: 1}
  end

end
