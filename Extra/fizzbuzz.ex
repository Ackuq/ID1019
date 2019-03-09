defmodule Fizzbuzz do

  def fizzbuzz(n) do fizzbuzz(1, n+1, 1, 1) end

  def fizzbuzz(n, n, _,_) do [] end

  def fizzbuzz(v, n, d3, d5) do
    case {d3, d5} do
      {3, 5} ->
        [:fizzbuzz | fizzbuzz(v+1, n, 1, 1)]
      {3, _} ->
        [:buzz | fizzbuzz(v+1, n, 1, d5 + 1)]
      {_, 5} ->
        [:fizz | fizzbuzz(v+1, n, d3 + 1, 1)]
      _ ->
        [v | fizzbuzz(v+1, n, d3+1 , d5+1)]
    end
  end
end
