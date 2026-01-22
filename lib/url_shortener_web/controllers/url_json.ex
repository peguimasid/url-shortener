defmodule UrlShortenerWeb.UrlJSON do
  alias UrlShortener.Urls.Url

  @doc """
  Renders a list of urls.
  """
  def index(%{urls: urls}) do
    %{data: for(url <- urls, do: data(url))}
  end

  @doc """
  Renders a single url.
  """
  def show(%{url: url}) do
    %{data: data(url)}
  end

  defp data(%Url{} = url) do
    %{
      id: url.id,
      url: url.url,
      short_code: url.short_code,
      access_count: url.access_count
    }
  end
end
