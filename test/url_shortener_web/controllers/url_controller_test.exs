defmodule UrlShortenerWeb.UrlControllerTest do
  use UrlShortenerWeb.ConnCase

  import UrlShortener.UrlsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create url" do
    test "renders url when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/shorten", url: "https://example.com/some-page")

      assert %{
               "id" => id,
               "url" => "https://example.com/some-page",
               "short_code" => short_code,
               "access_count" => 0
             } = json_response(conn, 201)["data"]

      assert is_integer(id)
      assert is_binary(short_code)
      assert String.length(short_code) > 0
    end

    test "renders errors when url is missing", %{conn: conn} do
      conn = post(conn, ~p"/api/shorten", url: nil)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when url is invalid format", %{conn: conn} do
      conn = post(conn, ~p"/api/shorten", url: "not a valid url")
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "get_by_code" do
    test "renders url when short_code exists", %{conn: conn} do
      url = url_fixture()

      conn = get(conn, ~p"/api/shorten/#{url.short_code}")

      assert %{
               "id" => id,
               "url" => _,
               "short_code" => short_code,
               "access_count" => 0
             } = json_response(conn, 200)["data"]

      assert id == url.id
      assert short_code == url.short_code
    end

    test "returns 404 when short_code does not exist", %{conn: conn} do
      assert_error_sent 404, fn ->
        get(conn, ~p"/api/shorten/nonexistent")
      end
    end
  end
end
