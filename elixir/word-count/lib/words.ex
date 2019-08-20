defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.split(~r/[ _!@#$%^&*()+=:,]/, trim: true)
    |> Stream.map( &String.downcase(&1) )
    |> Stream.filter( &filter_out_blanks/1 )
    |> Enum.reduce( %{}, &word_count/2 )
  end

  defp filter_out_blanks(word) do
    len = to_charlist(word) |> length
    len > 0
  end

  defp word_count(word, acc_map) do
    Map.update(acc_map, word, 1, &(&1 + 1))
  end
end