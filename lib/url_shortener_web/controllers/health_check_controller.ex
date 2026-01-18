defmodule UrlShortenerWeb.HealthCheckController do
  use UrlShortenerWeb, :controller

  def index(conn, _params) do
    send_resp(conn, 200, "")
  end
end
