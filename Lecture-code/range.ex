defmodule Range do
  @moduledoc """
    Lecture about higher order functions.
  """
  def sum(r) do
    reduce(r, 0, fn(x, a) -> x+a end)
  end

  def reduce({:range, from, to}, acc, fun) do
    if from <= to do
      reduce({:range, from+1, to}, fun.(from,acc), fun)
    else
      acc
    end
  end


  def sumCont(r) do
    reduceCont(r, {:cont, 0}, fn(x, a) -> {:cont, x+a} end)
  end

  # This function can get a certain number of elements in the range
  def reduceCont({:range, from, to}, {:cont, acc}, fun) do
    if from <= to do
      reduceCont({:range, from+1, to}, fun.(from, acc), fun)
    else
      {:done, acc}
    end
  end
  def reduceCont(_, {:halt, acc}, _fun) do
    {:halted, acc}
  end

  # n is the number of elements in the range that should be taken
  def take(r, n) do
    reduceCont(r, {:cont, {:sofar, 0, [] }},
    fn(x, {:sofar, s, a}) ->
      if s == n do
        {:halt, Enum.reverse(a)}
      else
        {:cont, {:sofar, s+1, [x | a]}}
      end
    end)
  end
end
