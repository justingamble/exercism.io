defmodule BitDesc do
   defstruct bit: 0, desc: "unset"
end

defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  use Bitwise

  @wink               %BitDesc{bit: 0b0001, desc: "wink"}
  @double_blink       %BitDesc{bit: 0b0010, desc: "double blink"}
  @close_your_eyes    %BitDesc{bit: 0b0100, desc: "close your eyes"}
  @jump               %BitDesc{bit: 0b1000, desc: "jump"}

  @reverse_string_bit   0b10000

  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    actions = [@wink, @double_blink, @close_your_eyes, @jump]
    reversed_list = Enum.reduce(actions, [], fn action, acc ->
      check_actions(code, action, acc)
    end)

    if bit_is_set(code, @reverse_string_bit) do
      # Reverse the list.  No changes; string is already reversed
      reversed_list
    else
      Enum.reverse(reversed_list)
    end
  end

  defp check_actions(code, %BitDesc{bit: bit, desc: desc}, acc) do
    if bit_is_set(code, bit) do
      [ desc ] ++ acc
    else
      acc
    end
  end

  defp bit_is_set(number, bit_pattern) do
    (number &&& bit_pattern) == bit_pattern
  end


  ## The above is my solution.
  ## Alternative solutions:

  ## 1. From 'ewired'.  Probably the shortest possible solution:

  # @spec commands(code :: integer) :: list(String.t())
  # def commands(code) do
  #   cmds = []
  #   cmds = if (8 &&& code) == 8, do: ["jump" | cmds], else: cmds
  #   cmds = if (4 &&& code) == 4, do: ["close your eyes" | cmds], else: cmds
  #   cmds = if (2 &&& code) == 2, do: ["double blink" | cmds], else: cmds
  #   cmds = if (1 &&& code) == 1, do: ["wink" | cmds], else: cmds
  #   cmds = if (16 &&& code) == 16, do: Enum.reverse(cmds), else: cmds
  #   cmds
  # end

  ## 2. From 'valentiniljaz'.  This user found the way to represent decimals
  ## as binary:    Integer.digits(code, 2).
  ## Also interesting is the solution does *not* involve the Bitwise &&&/2
  ## function.

  # @spec commands(code :: integer) :: list(String.t())
  # def commands(code) do
  #   Integer.digits(code, 2) |> Enum.reverse |> steps(1, [])
  # end
  #
  # defp steps([h | t], step, acc) do
  #   steps(t, step+1, step_hand(h, step, acc))
  # end
  #
  # defp steps([], _, acc) do
  #   acc
  # end
  #
  # defp step_hand(1, step, acc) do
  #   case step do
  #     1 -> acc ++ ["wink"]
  #     2 -> acc ++ ["double blink"]
  #     3 -> acc ++ ["close your eyes"]
  #     4 -> acc ++ ["jump"]
  #     5 -> Enum.reverse(acc)
  #     _ -> acc
  #   end
  # end
  #
  # defp step_hand(0, _, acc) do
  #   acc
  # end
  #
  ## 3. From 'garyharan'.  I appreciate the way the for() loop is used
  ## with a guard, and I also think it is clever to use a macro to
  ## determine if the entire list should be reversed.

  # defmacrop is_reversible(code) do
  #   quote do: Bitwise.band(0b10000, unquote(code)) != 0
  # end
  #
  # @actions %{
  #   1 => "wink",
  #   2 => "double blink",
  #   4 => "close your eyes",
  #   8 => "jump"
  # }
  #
  # def commands(code) when is_reversible(code) do
  #   commands(code - 0b10000)
  #   |> Enum.reverse
  # end
  #
  # def commands(code) do
  #   for {key, val} <- @actions , (code &&& key) > 0, do: val
  # end
end
