defmodule WorkTimeTracker.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create_if_not_exists(table(:cards, primary_key: false)) do
      add :card_uid, :uuid, primary_key: true, null: false
      add :title, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create_if_not_exists(index(:cards, [:user_id]))
  end
end
