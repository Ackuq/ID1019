defmodule Fizzbuzz do

  def fizzbuzz(n) do fizzbuzz(1, n+1, 1, 1) end

  def fizzbuzz(n, n, _,_) do [] end

  def fizzbuzz(v, n, d3, d5) do
    r3 = div3(v + 1)
    r5 = div5(v + 1)
    case {d3, d5} do
      {0, 0} ->
        [:fizzbuzz | fizzbuzz(v+1, n, r3, r5)]
      {1, 0} ->
        [:buzz | fizzbuzz(v+1, n, r3, r5)]
      {0, 1} ->
        [:fizz | fizzbuzz(v+1, n, r3, r5)]
      _ ->
        [v | fizzbuzz(v+1, n, r3, r5)]
    end
  end

  def div3(n) when n < 0, do: 1
  def div3(0) do 0 end
  def div3(n) do div3(n + (-3)) end

  def div5(n) when n < 0, do: 1
  def div5(0) do 0 end
  def div5(n) do div5(n + (-5)) end
end
