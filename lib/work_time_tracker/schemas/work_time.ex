defmodule WorkTimeTracker.Schemas.WorkTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "work_times" do
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :free_schedule, :boolean, default: false
    field :type_exclusion, Ecto.Enum, values: [:vacation, :sick_leave, :come_later, :leave_earlier, :full_working_day], default: :full_working_day
    belongs_to :user, WorkTimeTracker.Schemas.User, foreign_key: :user_id
  end

  def changeset(work_time, attrs) do
    work_time
    |> cast(attrs, [:start_time, :end_time, :free_schedule, :type_exclusion, :user_id])
    |> validate_required([:start_time, :end_time, :free_schedule, :type_exclusion, :user_id])
    |> foreign_key_constraint(:user_id)
    |> validate_inclusion(:type_exclusion, [:vacation, :sick_leave, :come_later, :leave_earlier, :full_working_day])
  end
end
