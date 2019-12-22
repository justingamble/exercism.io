defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.downcase
    |> String.replace("_", " ")
    |> filter_out_invalid_chars
    |> String.split
    |> create_map_counts
  end

  defp filter_out_invalid_chars(sentence) do
    String.replace(sentence, ~r/[^\w\s\-]/u, "")
  end

  defp create_map_counts(list) do
    Enum.reduce(list, %{}, &word_count/2 )
  end

  defp word_count(word, acc_map) do
    Map.update(acc_map, word, 1, &(&1 + 1))
  end

  ## Alternatively, the below also works, but I prefer the above because
  ## a) the String.split parameters are simpler, and
  ## b) it does not hardcode all the characters we want to exclude.
  #
  # @non_alphanum_char ~r/[[:blank:]_!@#$%^&*()+=:,]/u
  #
  # @spec count(String.t()) :: map
  # def count(sentence) do
  #   sentence
  #   |> String.downcase
  #   |> split_into_list
  #   |> create_map_counts
  # end
  #
  # defp split_into_list(sentence) do
  #   String.split(sentence, @non_alphanum_char, trim: true)
  # end
  #
  # defp create_map_counts(list) do
  #   Enum.reduce(list, %{}, &word_count/2 )
  # end
  #
  # defp word_count(word, acc_map) do
  #   Map.update(acc_map, word, 1, &(&1 + 1))
  # end
end
