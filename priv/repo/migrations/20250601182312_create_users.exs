defmodule WorkTimeTracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create_if_not_exists(table(:users)) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false

      timestamps()
    end
  end
end
