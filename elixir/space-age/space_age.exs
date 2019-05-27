defmodule SpaceAge do
  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune
  @earth_seconds_in_year 31557600
  @orb_period_relative_to_earth_years %{
    mercury: 0.2408467,
    venus:   0.61519726,
    mars:    1.8808158,
    jupiter: 11.862615,
    saturn:  29.447498,
    uranus:  84.016846,
    neptune: 164.79132
  }

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet'.
  """
  @spec age_on(planet, pos_integer) :: float
  def age_on(planet, seconds) do
    earth_years = get_earth_years(seconds)
    case planet do
      :earth -> earth_years
      _ -> earth_years / @orb_period_relative_to_earth_years[planet]
    end
  end

  defp get_earth_years(seconds) do
    seconds / @earth_seconds_in_year
  end
end
