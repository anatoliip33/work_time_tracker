defmodule WorkTimeTracker.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)

    has_many(:cards, WorkTimeTracker.Schemas.Card)
    has_many(:work_times, WorkTimeTracker.Schemas.WorkTime)

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
  end
end
