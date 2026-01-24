defmodule UrlShortener.Urls.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :url, :string
    field :short_code, :string
    field :access_count, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  @url_regex ~r/^https?:\/\/[^\s\/$.?#].[^\s]*$/i

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:url, :short_code])
    |> validate_required([:url])
    |> validate_format(:url, @url_regex, message: "must be a valid URL starting with http:// or https://")
    |> validate_length(:url, max: 2048, message: "must be at most 2048 characters")
    |> unique_constraint(:short_code)
  end
end
