defmodule WorkTimeTracker.Repo.Migrations.CreateWorkTimes do
  use Ecto.Migration

  def change do
    create_if_not_exists(table(:work_times)) do
      add :start_datetime, :utc_datetime, null: false
      add :end_datetime, :utc_datetime, null: false
      add :free_schedule, :boolean, default: false, null: false
      add :type_exculsion, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end

    create_if_not_exists(index(:work_times, [:user_id]))
  end
end
