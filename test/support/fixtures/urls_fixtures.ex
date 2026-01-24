defmodule UrlShortener.UrlsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UrlShortener.Urls` context.
  """

  @doc """
  Generate a unique url.
  """
  def unique_url, do: "https://example.com/page/#{System.unique_integer([:positive])}"

  @doc """
  Generate a url.
  """
  def url_fixture(attrs \\ %{}) do
    {:ok, url} =
      attrs
      |> Enum.into(%{
        url: unique_url()
      })
      |> UrlShortener.Urls.create_url()

    url
  end
end
