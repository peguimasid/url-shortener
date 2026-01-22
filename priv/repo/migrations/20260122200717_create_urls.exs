defmodule UrlShortener.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :url, :string
      add :short_code, :string
      add :access_count, :integer, default: 0

      timestamps(type: :utc_datetime)
    end

    create unique_index(:urls, [:short_code])
  end
end
