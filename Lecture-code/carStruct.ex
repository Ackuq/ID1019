defmodule Car do
  @moduledoc """
    An example of usage of struct,
    Key-value structure.
  """

  defstruct brand: "", year: 0, model: "", cyl: 0, power: 0

  # Create a new car
  def newCar() do %Car{:brand => "", :year => 0, :model => "", :cyl => 0, :power => 0} end
  def newCar(brand, year, model, cyl, power) do
    %Car{:brand => brand, :year => year, :model => model, :cyl => cyl, :power => power}
  end

  # Return specific data
  def brand_model(%Car{brand: brand, model: model}) do
    "#{brand} #{model}"
  end

  def year(car = %Car{}) do
    car.year
  end
end
