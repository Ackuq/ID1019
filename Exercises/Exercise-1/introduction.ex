defmodule Introduction do
#------------------
# A first program
#------------------
# Compute the double of a number
  def double(n) do
    2*n
  end

  #a function that converts from Fahrenheit to Celsius (the function is as
  #follows: C = (F − 32)/1.8)
  def toCelsius(f) do
    (f - 32)/1.8
  end

  #a function that calculates the area of a rectangle give the length of the
  #two sides
  def areaRec(b, h) do
    b * h
  end

  #a function that calculates the area of a square, using the previous
  #function
  def areaSq(x) do
    areaRec(x, x)
  end

  #a function that calculates the area of a circle given the radius
  def areaCirc(r) do
    :math.pi * :math.pow(r, 2)
  end

  #-----------------------
  # Recursive functions
  #-----------------------

  # Calculate the product of m and n
  def product(m, n) do
    case m do
      0 -> 0
      _ -> n + product(m-1, n)
    end
  end

  # Calculate x raised to the nth power
  def exp(x, n) do
    case n do
      0 -> 1
      1 -> x
      _ -> product(x, exp(x, n-1))
    end
  end

  # Calculate x raised to the nth power, but faster
  def expFast(x, n) do
    cond do
      n == 1 -> x
      rem(n, 2) == 0 -> expFast(x, div(n,2)) * expFast(x, div(n,2))
      true -> expFast(x, n-1) * x
    end
  end

  #-----------------------
  # Lists
  #-----------------------

    # return the n'th element of the list l
  def nth(n, _list = [head | tail]) do
    case n do
      0 -> head
      _ -> nth(n-1, tail)
    end
  end

  # return the number of elements in the list l
  def len(_list = [_head | tail]) do
    case tail do
      [] -> 1
      _ -> 1 + len(tail)
    end
  end

  # return the sum of all elements in the list l, assume that
  #all elements are integers
  def sum(_list = [head | tail]) do
    case tail do
      [] -> head
      _ -> head + sum(tail)
    end
  end

    #return a list where all elements are duplicated
  def duplicate(_list = [head | tail]) do
    case tail do
      [] -> [head]
      _ -> [head | [head | duplicate(tail)]]
    end
  end

  #add the element x to the list l if it is not in the list
  def add(x, list = [head | tail]) do
    cond do
      head == x -> list
      tail == [] -> [head | [x]]
      true -> [head | add(x, tail)]
    end
  end

    #return a list of unique elements in the list l, that is [:a,
    #:b, :d] are the unique elements in the list [:a, :b, :a, :d, :a,
    #:b, :b, :a]

    # Function that return true if element is present in list
    # false if otherwise
  def contains(element, list) do
    case list do
      [] -> false
      [head | _tail] when element == head -> true
      [_head | tail] -> contains(element, tail);
    end
  end

  # Start with an empty list for the unique elements
  def unique(list) do unique(list, []) end

  # If we have reached the end of the list, return our lists
  # of unique elements
  def unique([], unique_list) do unique_list end

    # Check if the the next element is present in our unique list
    # If present -> move on
    # If not present -> add to unique list and move on
  def unique(_list = [head | tail], unique_list) do
    case contains(head, unique_list) do
      true -> unique(tail, unique_list)
      false -> unique(tail, unique_list ++ [head])
    end
  end

    #pack(l): return a list containing lists of equal elements, [:a, :a, :b,
    #:c, :b, :a, :c] should return [[:a, :a, :a], [:b, :b], [:c, :c]]

  def pack(_list) do

  end

  #return a list where the order of elements is reversed
  def reverse(l) do
    [head | tail] = l
    case tail do
      [] -> [head]
      _ ->  reverse(tail) ++ [head]
    end
  end


  #-----------------------
  # Sorting
  #-----------------------

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