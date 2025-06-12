defmodule WorkTimeTracker.Cards.Card do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cards" do
    field(:card_uid, Ecto.UUID)
    belongs_to(:user, WorkTimeTracker.Users.User, foreign_key: :user_id)

    timestamps()
  end

  def changeset(card, attrs) do
    card
    |> cast(attrs, [:card_uid, :user_id])
    |> validate_required([:card_uid, :user_id])
    |> unique_constraint(:card_uid)
    |> foreign_key_constraint(:user_id)
  end
end
