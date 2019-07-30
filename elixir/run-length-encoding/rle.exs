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
    IO.puts("decode entered.  string=#{string}")
    chars = to_charlist(string)
    {next_elem, rest} = List.pop_at(chars, 0)
    IO.inspect("string=#{string}, next_elem=#{to_string(next_elem)}, rest=#{rest}")
    if next_elem do
      list = Enum.chunk_by(chars, &(_digit?(&1)))
#      {next_elem, rest} = List.pop_at(list, 0)
      string = _decode([], nil, hd(list), tl(list))
      IO.puts("The final string is: #{string}")
      string
    else
      IO.puts("The else clause in the original decode")

      ""
    end
  end

  def _decode(acc, _repeat, nil, _rest) do
    IO.puts("***** _decode.  END CONDITION REACHED")
    to_string(acc)
  end

  def _decode(acc, repeat, [head | tail] = elem, rest) when head >= ?A and head <= ?z and is_nil(repeat) do
    IO.puts("***** _decode.  ALPHA FOUND (head=#{inspect head}, NO REPEAT).")
    IO.inspect binding()

    {next_elem, new_rest} = List.pop_at(rest, 0)
    new_acc = [acc | elem] |> List.flatten()
    _decode( new_acc, nil, next_elem, new_rest )
  end

#  def _decode(acc, repeat, [head | tail] = elem, rest) when head > ?A and head < ?z and is_integer(repeat) do
  def _decode(acc, repeat, [head | tail] = elem, rest) when head >= ?A and head <= ?z do
    IO.puts("***** _decode.  ALPHA FOUND (head=#{inspect head}, repeat=#{inspect repeat}).")
    IO.inspect binding()

    repeated_head = String.duplicate( List.to_string([head]), repeat)
                    |> to_charlist()

    IO.puts("   --> repeated_head is '#{inspect repeated_head}'")
    {next_elem, new_rest} = List.pop_at(rest, 0)

    new_acc = [acc | [repeated_head | tail]] |> List.flatten()
    _decode( new_acc, nil, next_elem, new_rest )
  end

  def _decode(acc, repeat, [head | tail] = elem, rest) when head == ?  do
    IO.puts("***** _decode.  SPACE LIST FOUND (head=#{inspect head}, repeat=#{inspect repeat}).")
    IO.inspect binding()

    repeated_head = String.duplicate( " ", repeat)
                    |> to_charlist()

    IO.puts("   --> repeated_head is '#{inspect repeated_head}'")
    {next_elem, new_rest} = List.pop_at(rest, 0)

    new_acc = [acc | [repeated_head | tail]] |> List.flatten()
    _decode( new_acc, nil, next_elem, new_rest )
  end

  def _decode(acc, repeat, head, rest) when head == ?  do
    IO.puts("***** _decode.  SPACE FOUND (head=#{inspect head}, repeat=#{inspect repeat}).")
    IO.inspect binding()

    repeated_head = String.duplicate( " ", repeat)
                    |> to_charlist()

    IO.puts("   --> repeated_head is '#{inspect repeated_head}'")
    {next_elem, new_rest} = List.pop_at(rest, 0)

    new_acc = [acc | repeated_head] |> List.flatten()
    _decode( new_acc, nil, next_elem, new_rest )
  end

  def _decode(acc, nil, elem, rest) do
    IO.puts("***** _decode.  INTEGER, #{inspect elem}.")
    IO.inspect binding()

    repeat_num = elem |> to_string |> String.to_integer
    IO.puts("Repeat num is #{repeat_num}")
    {next_elem, new_rest} = List.pop_at(rest, 0)

    [my_head | my_tail] = next_elem
    IO.puts("    ***** debug.")
    IO.inspect binding()
    if (my_head > ?A) do
      IO.puts("MY head is > ?A")
    end
    if (my_head < ?z) do
      IO.puts("MY head is < ?z")
    end
    _decode( acc, repeat_num, next_elem, new_rest )
  end

##  def _decode(acc, next_char, rest) when next_char > ?A and next_char < ?z do
##    IO.inspect("ALPHA.  String is #{inspect [next_char | rest]}")
###    [next_char | acc]
##   input = [next_char | rest]
##    IO.puts("input list is: #{input}")

##    IO.inspect("after chunk_by, list is #{inspect list}")

##    folded = List.foldl(list, {nil, []}, fn x, acc ->

##      merge(next_char, rest, acc) end)
##    IO.inspect("after folded, folded = #{inspect folded}")

##    input
##  end

  # elem -- is a list element, containing digits or alpha chars.
  # x -- may be a number, which is used in the next computer.  Or empty list.
  # n -- contains the number we parsed on previous list elem
  # acc -- the accumulator contains the string we are decoding.
#  def merge(next_char, rest, {n, acc} = accum)
#    when next_char > ?A and next_char < ?z and is_nil(n) do
#
#    next_acc = [acc | [next_char | rest]]  |> List.flatten()
#    IO.puts("ALPHA merge. I'm adding UNCHANGED next_char to accum (#{inspect acc}).  result is #{inspect next_acc}")
#    {nil, next_acc}
#  end
#
#  def merge(next_char, _rest, {n, acc} = accum)
#    when next_char > ?A and next_char < ?z do
#
#    next_acc = String.duplicate(next_char, n)
#    IO.puts("ALPHA merge. I'm adding n=#{n} of next_char to accum.  result is #{inspect next_acc}")
#    {nil, [accum | next_acc]}
#  end
#
#  def merge(next_char, rest, {n, acc} = accum) do
#     # we received a digit
#     digits = [next_char | rest]
#       |> List.flatten()
#     IO.puts("Digit merge... #{digits}")
#     {digits, acc}
#  end
#
#  def _decode(acc, next_char, rest) do
#    IO.inspect("NUMBER FOUND.  The number is #{inspect next_char}.  String is #{inspect [next_char | rest]}")
#    input = [next_char | rest]
#  end

  def _digit?(char) do
    char > ?0 and char < ?9
  end
end
