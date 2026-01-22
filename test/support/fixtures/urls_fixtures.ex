defmodule UrlShortener.UrlsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UrlShortener.Urls` context.
  """

  @doc """
  Generate a unique url short_code.
  """
  def unique_url_short_code, do: "some short_code#{System.unique_integer([:positive])}"

  @doc """
  Generate a url.
  """
  def url_fixture(attrs \\ %{}) do
    {:ok, url} =
      attrs
      |> Enum.into(%{
        access_count: 42,
        short_code: unique_url_short_code(),
        url: "some url"
      })
      |> UrlShortener.Urls.create_url()

    url
  end
end
