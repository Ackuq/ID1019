defmodule Test do

  # Computethe double of a number
  def double(n) do
    2*n
  end

  def toCelsius(f) do
    (f - 32)/1.8
  end

  def areaRec(b, h) do
    b * h
  end

  def areaCirc(r) do
    :math.pi * :math.pow(r, 2)
  end

  def product(m, n) do
    if m == 0 do
      0
    else
      n + product(m-1, n)
    end
  end

  def exp(x, n) do
    case n do
      0 -> 1
      1 -> x
      _ -> product(x, exp(x, n-1))
    end
  end

  def expFast(x, n) do
    cond do
      n == 1 -> x
      rem(n, 2) == 0 -> expFast(x, div(n,2)) * expFast(x, div(n,2))
      true -> expFast(x, n-1) * x
    end
  end
end
