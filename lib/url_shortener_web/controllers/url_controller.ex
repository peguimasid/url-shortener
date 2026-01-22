defmodule UrlShortenerWeb.UrlController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Urls
  alias UrlShortener.Urls.Url

  action_fallback UrlShortenerWeb.FallbackController

  def create(conn, %{"url" => url_params}) do
    with {:ok, %Url{} = url} <- Urls.create_url(url_params) do
      conn
      |> put_status(:created)
      |> render(:show, url: url)
    end
  end

  def get_by_code(conn, %{"short_code" => short_code}) do
    url = Urls.get_url!(short_code)
    render(conn, :show, url: url)
  end
end
