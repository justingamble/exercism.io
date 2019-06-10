defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    chars = to_charlist(string)
    {first_char, rest} = List.pop_at(chars, 0)
    if first_char do
      _encode([], first_char, 1, rest)
    else
      ""
    end
  end

  # We build up a char list in reverse, and then reverse it.
  # Params:
  #   acc - accumulator, building-up the string we will return
  #   char - next character we are considering
  #   char_count - the number of consecutive times we have counted 'char' so far
  #   rest - the rest of the string, without the leading 'char'
  def _encode(acc, char, char_count, []) when is_list(acc)
      and is_integer(char_count) do

    add_to_acc(acc, char, char_count)
    |> Enum.reverse()
    |> to_string()
  end

  def _encode(acc, char, char_count, rest) when is_list(acc)
      and is_integer(char_count) and is_list(rest) do

    {next_char, new_rest} = List.pop_at(rest, 0)
    if char == next_char do
      _encode(acc, char, char_count + 1, new_rest)
    else
      add_to_acc(acc, char, char_count)
      |> _encode(next_char, 1, new_rest)
    end
  end

  def add_to_acc(acc, char, 1) when is_list(acc) do
    [char | acc]
  end

  def add_to_acc(acc, char, char_count) when is_list(acc) and is_integer(char_count) do
    size_list = char_count |> Integer.to_char_list()
    [char | [size_list | acc]]
  end

  @spec decode(String.t()) :: String.t()
  def decode(string) do
  end
end
