defmodule Types do
  @moduledoc """
    Lecture about types.
  """

  @type tuples() :: {} | {atom(), integer()}

  # Built in types
  #@type boolean() :: true | false
  #@type number() :: integer() | float()


  @doc """
    Here we define a card, a card has a suit and a value.
  """

  @type value() :: 1..13
  @type suit() :: :spade | :heart | :diamond | :clubs
  @type card() :: {:card, suit(), value()}
  @type deck() :: list(card())

  @spec suit(card()) :: suit()
  def suit({_, suit, _}) do
    suit
  end

  @doc """
    Here we define a person. Defined by age, name and gender
  """
  @type person() :: {:person, integer(), binary(), binary()}
  def hello({:person, _, name, _}) do
    IO.write("Hello #{name}")
  end


  @doc """
    Define a car, it is defined by model, engine, brand, and performance 
  """
  @type model() :: {:model, String.t(), integer()}
  @type engine() :: {:engine, String.t(), integer(), integer(), integer()}
  @type perf() :: {:perf, float(), float()}
  @type car() :: {:car, String.t(), model(), engine(), perf()}
  @spec car_brand_model(car()) :: String.t()
  def car_brand_model( {:car, brand, {:model, model, _}, _ , _}) do
    "#{brand} #{model}"
  end

end
