defmodule WorkTimeTracker.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create_if_not_exists(table(:cards)) do
      add :card_uid, :uuid, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create(unique_index(:cards, [:card_uid]))
    create_if_not_exists(index(:cards, [:user_id]))
  end
end
