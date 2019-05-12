defmodule NucleotideCount do
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a DNA strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count([char], char) :: non_neg_integer
  def count(strand, nucleotide) do
    strand
    |> histogram
    |> Map.get(nucleotide)
  end

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram([char]) :: map
  def histogram(strand) do
    count_characters(strand)
  end

  defp count_characters(strand) when is_list(strand) do
    initial_map = @nucleotides |> Map.new(fn key -> {key, 0} end)
    Enum.reduce(strand, initial_map, fn key, map ->
      if is_valid_nucleotide(key) do
        Map.update!(map, key, &(&1 + 1))
      else
        raise "Invalid nucleotide received: '#{inspect key}'."
          <> "  Expected one of: #{inspect @nucleotides}."
      end
    end)
  end

  defp is_valid_nucleotide(char) do
    Enum.member?(@nucleotides, char)
  end
end
