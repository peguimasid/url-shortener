defmodule UrlShortener.Urls do
  @moduledoc """
  The Urls context.
  """

  import Ecto.Query, warn: false
  alias UrlShortener.Repo

  alias UrlShortener.Urls.Url
  alias UrlShortener.Base62

  @doc """
  Returns the list of urls.

  ## Examples

      iex> list_urls()
      [%Url{}, ...]

  """
  def list_urls do
    Repo.all(Url)
  end

  @doc """
  Gets a single url.

  Raises `Ecto.NoResultsError` if the Url does not exist.

  ## Examples

      iex> get_url!(123)
      %Url{}

      iex> get_url!(456)
      ** (Ecto.NoResultsError)

  """
  def get_url!(id), do: Repo.get!(Url, id)

  @doc """
  Gets a single url by short_code.

  Raises `Ecto.NoResultsError` if the Url does not exist.

  ## Examples

      iex> get_url_by_code!("abc123")
      %Url{}

      iex> get_url_by_code!("invalid")
      ** (Ecto.NoResultsError)

  """
  def get_url_by_code!(short_code) do
    Repo.get_by!(Url, short_code: short_code)
  end

  @doc """
  Creates a url with a generated short_code.

  Uses a transaction to ensure the short_code is always set.

  ## Examples

      iex> create_url(%{url: "https://example.com"})
      {:ok, %Url{}}

      iex> create_url(%{url: nil})
      {:error, %Ecto.Changeset{}}

  """
  @dialyzer {:nowarn_function, create_url: 1}
  def create_url(attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:url, Url.changeset(%Url{}, attrs))
    |> Ecto.Multi.update(:url_with_code, fn %{url: url} ->
      short_code = Base62.encode(url.id)
      Url.changeset(url, %{short_code: short_code})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{url_with_code: url}} -> {:ok, url}
      {:error, :url, changeset, _} -> {:error, changeset}
      {:error, :url_with_code, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
  Updates a url.

  ## Examples

      iex> update_url(url, %{field: new_value})
      {:ok, %Url{}}

      iex> update_url(url, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_url(%Url{} = url, attrs) do
    url
    |> Url.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a url.

  ## Examples

      iex> delete_url(url)
      {:ok, %Url{}}

      iex> delete_url(url)
      {:error, %Ecto.Changeset{}}

  """
  def delete_url(%Url{} = url) do
    Repo.delete(url)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking url changes.

  ## Examples

      iex> change_url(url)
      %Ecto.Changeset{data: %Url{}}

  """
  def change_url(%Url{} = url, attrs \\ %{}) do
    Url.changeset(url, attrs)
  end
end
