defmodule UrlShortener.UrlsTest do
  use UrlShortener.DataCase

  alias UrlShortener.Urls

  describe "urls" do
    alias UrlShortener.Urls.Url

    import UrlShortener.UrlsFixtures

    @invalid_attrs %{url: nil}

    test "list_urls/0 returns all urls" do
      url = url_fixture()
      assert Urls.list_urls() == [url]
    end

    test "get_url!/1 returns the url with given id" do
      url = url_fixture()
      assert Urls.get_url!(url.id) == url
    end

    test "get_url_by_code!/1 returns the url with given short_code" do
      url = url_fixture()
      assert Urls.get_url_by_code!(url.short_code) == url
    end

    test "get_url_by_code!/1 raises when short_code does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Urls.get_url_by_code!("nonexistent")
      end
    end

    test "create_url/1 with valid data creates a url with generated short_code" do
      valid_attrs = %{url: "https://example.com/page"}

      assert {:ok, %Url{} = url} = Urls.create_url(valid_attrs)
      assert url.url == "https://example.com/page"
      assert is_binary(url.short_code)
      assert String.length(url.short_code) > 0
      assert url.access_count == 0
    end

    test "create_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Urls.create_url(@invalid_attrs)
    end

    test "create_url/1 with invalid url format returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Urls.create_url(%{url: "not a url"})
      assert "must be a valid URL starting with http:// or https://" in errors_on(changeset).url
    end

    test "update_url/2 with valid data updates the url" do
      url = url_fixture()
      update_attrs = %{url: "https://updated.example.com/page"}

      assert {:ok, %Url{} = updated_url} = Urls.update_url(url, update_attrs)
      assert updated_url.url == "https://updated.example.com/page"
    end

    test "update_url/2 with invalid data returns error changeset" do
      url = url_fixture()
      assert {:error, %Ecto.Changeset{}} = Urls.update_url(url, @invalid_attrs)
      assert url == Urls.get_url!(url.id)
    end

    test "delete_url/1 deletes the url" do
      url = url_fixture()
      assert {:ok, %Url{}} = Urls.delete_url(url)
      assert_raise Ecto.NoResultsError, fn -> Urls.get_url!(url.id) end
    end

    test "change_url/1 returns a url changeset" do
      url = url_fixture()
      assert %Ecto.Changeset{} = Urls.change_url(url)
    end
  end
end
