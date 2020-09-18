defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  Max number is 3000.

    Roman  Value
    I      1
    V      5
    X      10
    L      50
    C      100
    D      500
    M      1000
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) when is_integer(number) and number > 0 do
    calc_numeral(number)
  end

  def calc_numeral(number) when number >= 1000 do
    "M" <> calc_numeral(number - 1000)
  end

  def calc_numeral(number) when number >= 900 do
    "CM" <> calc_numeral(number - 900)
  end

  def calc_numeral(number) when number >= 500 do
    "D" <> calc_numeral(number - 500)
  end

  def calc_numeral(number) when number >= 400 do
    "CD" <> calc_numeral(number - 400)
  end

  def calc_numeral(number) when number >= 100 do
    "C" <> calc_numeral(number - 100)
  end

  def calc_numeral(number) when number >= 90 do
    "XC" <> calc_numeral(number - 90)
  end

  def calc_numeral(number) when number >= 50 do
    "L" <> calc_numeral(number - 50)
  end

  def calc_numeral(number) when number >= 40 do
    "XL" <> calc_numeral(number - 40)
  end

  def calc_numeral(number) when number >= 10 do
    "X" <> calc_numeral(number - 10)
  end

  def calc_numeral(number) when number >= 9 do
    "IX" <> calc_numeral(number - 9)
  end

  def calc_numeral(number) when number >= 5 do
    "V" <> calc_numeral(number - 5)
  end

  def calc_numeral(number) when number >= 4 do
    "IV" <> calc_numeral(number - 4)
  end

  def calc_numeral(number) when number > 0 do
    "I" <> calc_numeral(number - 1)
  end

  def calc_numeral(number) do
    ""
  end

end

## Alternative 1: Jrlamsal1256's solution
## This uses the same concept as my solution, except that Enum.find() is used
## instead of multiple function heads.
#defmodule RomanNumerals do
#  @doc """
#  Convert the number to a roman number.
#  """
#  @spec numeral(pos_integer) :: String.t()
#  def numeral(0), do: ""
#
#  def numeral(number) do
#    map = [
#      {"M",  1000},
#      {"CM", 900},
#      {"D",  500},
#      {"CD", 400},
#      {"C",  100},
#      {"XC", 90},
#      {"L",  50},
#      {"XL", 40},
#      {"X",  10},
#      {"IX", 9},
#      {"V",  5},
#      {"IV", 4},
#      {"I",  1}
#    ]
#    {roman, normal} = Enum.find(map, fn {_, normal} -> number >= normal end)
#    roman <> numeral(number - normal)
#  end
#endi

## leandrog's solution
#defmodule RomanNumerals do
#  @doc """
#  Convert the number to a roman number.
#  """
#  @spec numeral(pos_integer) :: String.t()
#  def numeral(number) do
#    case number do
#      0 -> ""
#      9 -> "IX"
#      4 -> "IV"
#      x when div(x, 1000) > 0 -> "M" <> numeral(x - 1000)
#      x when x >= 900 -> "CM" <> numeral(x - 900)
#      x when div(x, 500) > 0 -> "D" <> numeral(x - 500)
#      x when x >= 400 -> "CD" <> numeral(x - 400)
#      x when div(x, 100) > 0 -> "C" <> numeral(x - 100)
#      x when x >= 90 -> "XC" <> numeral(x - 90)
#      x when div(x, 50) > 0 -> "L" <> numeral(x - 50)
#      x when x >= 40 -> "XL" <> numeral(x - 40)
#      x when div(x, 10) > 0 -> "X" <> numeral(x - 10)
#      x when div(x, 5) > 0 -> "V" <> numeral(x - 5)
#      x when x in 1..3 -> "I" <> numeral(x - 1)
#    end
#  end
#end
