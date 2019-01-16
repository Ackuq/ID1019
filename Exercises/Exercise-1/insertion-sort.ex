defmodule Sorting do

  #Start by defning a function insert(element, list),
  #that inserts the element at the right place in the list.
  def insert(element, list) do
    case list do
      [] -> [element]
      [head | tail] when head >= element -> [element | [ head | tail]]
      [head | tail] -> [head | insert(element, tail)]
    end
  end

  # Take first element and sort it
  def isort(_list = [head | tail]) do
    isort([head], tail)
  end

  # If all elements have been checked, return the sorted list
  def isort(sorted_list, unsorted_list) do
    case unsorted_list do
      [] -> sorted_list
      [head | tail] -> insert(head, sorted_list) |> isort(tail)
    end
  end
end
