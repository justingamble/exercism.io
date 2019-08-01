defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
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
    [char | [Integer.to_charlist(char_count) | acc]]
  end

  # Reconstruct the data into its original form.
  #
  # Examples:
  #    iex> RunLengthEncoder.decode("2A3B4C")
  #    "AABBBCCCC"
  @spec decode(String.t()) :: String.t()
  def decode(string) do
    chars = to_charlist(string)
    {next_elem, _rest} = List.pop_at(chars, 0)
    if next_elem do
      # break into sublists of chars or integers
      list = Enum.chunk_by(chars, &(&1 >= ?0 and &1 <= ?9))
       _decode([], nil, hd(list), tl(list))
    else
      ""
    end
  end

  # _decode Params:
  #   acc - accumulator, building-up the string we will return
  #   repeat - if previous batch contained a number, then this is that number
  #   elem - current batch (sublist) being processed.  contains alphas or numbers.
  #   rest - the rest of the list to be processed, without the leading 'elem'

  # Stop condition.  No more input.  Return string we have accumulated.
  def _decode(acc, _repeat, [], []) do
    to_string(acc)
  end

  # ELEM starts with an alphabet character or space character, with NO known repeat
  def _decode(acc, repeat, [head | _tail] = elem, rest)
      when ((head >= ?A and head <= ?z) or (head == ?\s)) and is_nil(repeat) do

    new_acc = [acc | elem] |> List.flatten()
    {next_elem, new_rest} = List.pop_at(rest, 0, []) # next_elem is [] if rest is []
    _decode( new_acc, nil, next_elem, new_rest )
  end

  # ELEM starts with an alphabet character or space character, with a known repeat
  def _decode(acc, repeat, [head | tail] = _elem, rest)
      when (head >= ?A and head <= ?z) or (head == ?\s) do

    # List.to_string([head]) forces a character representation
    repeated_head = String.duplicate( List.to_string([head]), repeat)
                    |> to_charlist()
    new_acc = [acc | [repeated_head | tail]] |> List.flatten()
    {next_elem, new_rest} = List.pop_at(rest, 0, []) # next_elem is [] if rest is []
    _decode( new_acc, nil, next_elem, new_rest )
  end

  # ELEM contains a number
  def _decode(acc, nil, elem, rest) do
    repeat_num = elem |> to_string |> String.to_integer
    _decode( acc, repeat_num, hd(rest), tl(rest) )
  end

  ## *************************************************************
  ## The above is my solution.
  ## Alternative solutions:

  ## -------------------------------------------------------------
  ## 1. From 'paulfioravanti'.  Kudos for being a short solution!
  #
  #  defmodule RunLengthEncoder do
  #    # NOTE: \1 backreferences the single character match in parentheses.
  #    # The parentheses only serve to provide a match for the backreference.
  #    @consecutive_data_elements ~r{([A-Za-z\s])\1+}
  #    @run_length_encoding ~r{\d+\D}
  #
  #    @spec encode(String.t()) :: String.t()
  #    def encode(""), do: ""
  #
  #    def encode(string) do
  #      @consecutive_data_elements
  #      |> Regex.replace(string, &compress/2)
  #    end
  #
  #    @spec decode(String.t()) :: String.t()
  #    def decode(""), do: ""
  #
  #    def decode(string) do
  #      @run_length_encoding
  #      |> Regex.replace(string, &reconstruct/1)
  #    end
  #
  #    defp compress(whole_match, letter) do
  #      "#{String.length(whole_match)}#{letter}"
  #    end
  #
  #    defp reconstruct(whole_match) do
  #      {count, character} = Integer.parse(whole_match)
  #      String.duplicate(character, count)
  #    end
  #  end

  ## -------------------------------------------------------------
  ## 2. From 'nshafer.exs'.  I like the clarity of this solution.
  #
  #  defmodule RunLengthEncoder do
  #    @spec encode(String.t()) :: String.t()
  #    def encode(""), do: ""
  #
  #    def encode(string) do
  #      string
  #      |> String.graphemes()
  #      |> Enum.chunk_by(fn str -> str end)
  #      |> Enum.map(&encode_chunk/1)
  #      |> List.to_string()
  #    end
  #
  #    defp encode_chunk(chunk) do
  #      len = length(chunk)
  #      chr = List.first(chunk)
  #      if len > 1 do
  #        to_string(len) <> chr
  #      else
  #        chr
  #      end
  #    end
  #
  #    @spec decode(String.t()) :: String.t()
  #    def decode(string) do
  #      Regex.scan(~r/\d*[\w\s]/, string)
  #      |> Enum.concat()
  #      |> Enum.map(&decode_chunk/1)
  #      |> List.to_string()
  #    end
  #
  #    defp decode_chunk(chunk) do
  #      case Integer.parse(chunk) do
  #        :error -> chunk
  #        {count, str} -> String.duplicate(str, count)
  #      end
  #    end
  #  end

end
