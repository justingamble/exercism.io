defmodule RNATranscription do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    Enum.map(dna, &transcribe/1)
  end

  defp transcribe(?G), do: ?C
  defp transcribe(?C), do: ?G
  defp transcribe(?T), do: ?A
  defp transcribe(?A), do: ?U


  ## Alternate solution (earlier version of this same solution).
  ## This alternate solution uses Enum.reduce/3 instead of Enum.map/2

  # def to_rna(dna) do
  #    Enum.reduce(dna, [], fn x, acc -> acc ++ transcribe(x) end)
  # end
  #
  # defp transcribe(?G), do: [?C]
  # defp transcribe(?C), do: [?G]
  # defp transcribe(?T), do: [?A]
  # defp transcribe(?A), do: [?U]
end
