defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.downcase
    |> split_into_list
    |> create_map_counts
  end

  defp split_into_list(sentence) do
    String.split(sentence, ~r/[[:blank:]_!@#$%^&*()+=:,]/u, trim: true)
  end

  defp create_map_counts(list) do
    Enum.reduce(list, %{}, &word_count/2 )
  end

  defp word_count(word, acc_map) do
    Map.update(acc_map, word, 1, &(&1 + 1))
  end
end
