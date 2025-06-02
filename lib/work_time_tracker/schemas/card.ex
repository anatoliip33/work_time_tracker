defmodule WorkTimeTracker.Schemas.Card do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:card_uid, Ecto.UUID, autogenerate: true}

  schema "cards" do
    field :title, :string
    belongs_to :user, WorkTimeTracker.Schemas.User, foreign_key: :user_id

    timestamps()
  end

  def changeset(card, attrs) do
    card
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
