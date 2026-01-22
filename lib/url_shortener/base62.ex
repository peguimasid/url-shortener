defmodule UrlShortener.Base62 do
  @moduledoc """
  Base62 encoding/decoding using characters a-z, A-Z, 0-9.
  """

  @base62_chars "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
                |> String.graphemes()

  @doc """
  Encodes an integer to a base62 string.

  ## Examples

      iex> UrlShortener.Base62.encode(0)
      "0"

      iex> UrlShortener.Base62.encode(62)
      "10"

      iex> UrlShortener.Base62.encode(125)
      "1z"
  """
  def encode(number) when is_integer(number) and number >= 0 do
    do_encode(number, [])
  end

  defp do_encode(0, []), do: "0"
  defp do_encode(0, acc), do: Enum.join(acc)

  defp do_encode(number, acc) do
    remainder = rem(number, 62)
    char = Enum.at(@base62_chars, remainder)
    do_encode(div(number, 62), [char | acc])
  end

  @doc """
  Decodes a base62 string to an integer.

  ## Examples

      iex> UrlShortener.Base62.decode("0")
      0

      iex> UrlShortener.Base62.decode("10")
      62

      iex> UrlShortener.Base62.decode("1z")
      125
  """
  def decode(string) when is_binary(string) do
    string
    |> String.graphemes()
    |> Enum.reduce(0, fn char, acc ->
      index = Enum.find_index(@base62_chars, &(&1 == char))
      acc * 62 + index
    end)
  end
end
