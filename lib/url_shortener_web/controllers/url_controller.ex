defmodule UrlShortenerWeb.UrlController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Urls
  alias UrlShortener.Urls.Url

  action_fallback UrlShortenerWeb.FallbackController

  def create(conn, %{"url" => url}) do
    with {:ok, %Url{} = url_record} <- Urls.create_url(%{url: url}) do
      conn
      |> put_status(:created)
      |> render(:show, url: url_record)
    end
  end

  def get_by_code(conn, %{"short_code" => short_code}) do
    url = Urls.get_url_by_code!(short_code)
    render(conn, :show, url: url)
  end
end
