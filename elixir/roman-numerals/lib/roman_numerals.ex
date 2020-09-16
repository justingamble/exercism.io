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
