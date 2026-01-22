defmodule UrlShortener.Urls.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :url, :string
    field :short_code, :string
    field :access_count, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:url, :short_code])
    |> validate_required([:url])
    |> unique_constraint(:short_code)
  end
end
