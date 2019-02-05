defmodule Ininite do
  @moduledoc """
    Lecture about higher order functions
  """

  def infinity() do
    fn() -> infinity(0) end
  end

  def infinity(n) do
    [n | infinity(n)]
  end

  def fib() do
    fn() -> fib(1,1) end
  end

  def fib(f1, f2) do
    [f1 | fn() -> fib(f2, f1+f2)]
  end
end
