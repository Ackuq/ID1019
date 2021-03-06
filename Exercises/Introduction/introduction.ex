defmodule Introduction do
#------------------
# 2. A first program
#------------------
# Compute the double of a number
  def double(n) do 2*n end

  #a function that converts from Fahrenheit to Celsius (the function is as
  #follows: C = (F − 32)/1.8)
  def toCelsius(f) do (f - 32)/1.8 end

  #a function that calculates the area of a rectangle give the length of the
  #two sides
  def areaRec(b, h) do b * h end

  #a function that calculates the area of a square, using the previous
  #function
  def areaSq(x) do areaRec(x, x) end

  #a function that calculates the area of a circle given the radius
  def areaCirc(r) do product(:math.pi, expFast(r, 2)) end

#-----------------------
# 3. Recursive functions
#-----------------------

  # Calculate the product of m and n
  def product(0, _) do 0 end
  def product(m, n) do n + product(m-1, n) end

  # Calculate x raised to the nth power
  def exp(_, 0) do 1 end
  def exp(x, 1) do x end
  def exp(x, n) do product(x, exp(x, n-1)) end

  # Calculate x raised to the nth power, but faster
  def expFast(x, 1) do x end
  def expFast(x, n) when rem(n, 2) == 0 do product( expFast(x, div(n,2)) , expFast(x, div(n,2)) ) end
  def expFast(x, n) do product( x , expFast(x, n-1) ) end

#-----------------------
# 4. List Operations
#-----------------------

  # return the n'th element of the list l
  def nth(0, [head | _]) do head end
  def nth(n, [_ | tail]) do nth(n-1, tail) end

  # return the number of elements in the list l
  def len([]) do 0 end
  def len([ _ | tail]) do 1 + len(tail) end

  # return the sum of all elements in the list l, assume that
  #all elements are integers
  def sum([]) do 0 end
  def sum([head | tail]) do head + sum(tail) end

  #return a list where all elements are duplicated
  def duplicate([]) do [] end
  def duplicate([head | tail]) do [head | [head | duplicate(tail)]] end

  #add the element x to the list l if it is not in the list
  def add(x, []) do [x] end
  def add(x, list = [x | _]) do list end
  def add(x, [head]) do [head | [x]] end
  def add(x, [head | tail]) do [head | add(x, tail)] end


  # remove all occurrences of x in l

  def remove( _ , []) do [] end
  def remove(x, [x | tail]) do remove(x, tail) end
  def remove(x, [head | tail]) do [head | remove(x, tail)] end


  #return a list of unique elements in the list l, that is [:a,
  #:b, :d] are the unique elements in the list [:a, :b, :a, :d, :a,
  #:b, :b, :a]

  # Function that return true if element is present in list
  # false if otherwise
  def contains(_, []) do false end
  def contains(element, [element | _]) do true end
  def contains(element, [_ | tail]) do contains(element, tail) end

  # Start with an empty list for the unique elements
  def unique(list) do unique(list, []) end

  # If we have reached the end of the list, return our lists
  # of unique elements
  def unique([], unique_list) do unique_list end

  # Check if the the next element is present in our unique list
  # If present -> move on
  # If not present -> add to unique list and move on
  def unique([head | tail], unique_list) do
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
  def reverseList([]) do [] end
  def reverseList([head | tail]) do reverse(tail) ++ [head] end

#-----------------------
# 4.1 Sorting
#-----------------------

#-----------------------
# 4.2 Insertion sort
#-----------------------

  #Start by defning a function insert(element, list),
  #that inserts the element at the right place in the list.
  def insert(element, []) do [element] end
  def insert(element, [head | tail]) when head >= element do
    [element | [ head | tail]]
  end
  def insert(element, [head | tail]) do
    [head | insert(element, tail)]
  end

  # Take first element and sort it
  def isort([head | tail]) do isort([head], tail) end

  # If all elements have been checked, return the sorted list
  def isort(sorted_list, []) do sorted_list end
  def isort(sorted_list, [head | tail]) do insert(head, sorted_list) |> isort(tail) end

#-----------------------
# 4.3 Merge sort
#-----------------------

  def msort([ head | [] ]) do [head] end
  def msort(list) do
    {list1, list2} = msplit(list, [], [])
    merge(msort(list1),msort(list2))
  end

  # Megre two sublists
  def merge(list1, []) do list1 end
  def merge([], list2) do list2 end
  def merge(list1 = [head1 | tail1], list2 = [head2 | tail2]) do
    cond do
      head1 < head2 -> [head1 | merge(tail1, list2)]
      true -> [head2 | merge(list1, tail2)]
    end
  end

  # Split list into two sublists until original list is empty
  def msplit([],list1, list2) do
    {list1, list2}
  end
  def msplit([head | tail],list1, list2) do
    msplit(tail, [head | list2], list1)
  end

#-----------------------
# 4.4 Quicksort
#-----------------------

  # low = sublist of elements smaller than pivot
  # high = sublist of elements larger than pivot
  def qsort([]) do [] end
  def qsort([pivot | list]) do
    {low , high} = qsplit(pivot, list, [], [])
    qappend(low, [pivot | high])
  end

  # Use the pivot and decide where to put the head of
  # the original list
  def qsplit(_, [], small, large) do {small, large} end
  def qsplit(pivot, [head | tail], small, large) when head < pivot do
    qsplit(pivot, tail, [head | small], large)
  end
  def qsplit(pivot, [head | tail], small, large) do
    qsplit(pivot, tail, small, [head | large])
  end

  # Append the list with the sorted left sublist and the sorted
  # right sublist
  def qappend(small, []) do small end
  def qappend(small, [h | t]) do qsort(small) ++ [h] ++ qsort(t) end

#-----------------------
# Performance analysis
#-----------------------
  def bench() do
    ls = [16, 32, 64, 128, 256, 512]
    n = 100
    # bench is a closure: a function with an environment.
    bench = fn(l) ->
      seq = Enum.to_list(1..l)
      tn = time(n, fn -> nreverse(seq) end)
      tr = time(n, fn -> reverse(seq) end)
      :io.format("length: ~10w nrev: ~8w us rev: ~8w us~n", [l, tn, tr])
    end
    # We use the library function Enum.each that will call
    # bench(l) for each element l in ls
    Enum.each(ls, bench)
  end

  # Time the execution time of the a function.
  def time(n, fun) do
    start = System.monotonic_time(:microsecond)
    loop(n, fun)
    stop = System.monotonic_time(:microsecond)
    stop - start
  end

  # Apply the function n times.
  def loop(n, fun) do
    if n == 0 do
      :ok
    else
      fun.()
      loop(n - 1, fun)
    end
  end

#-----------------------
# 5. Reverse
#-----------------------

  def nreverse([]) do [] end
  def nreverse([head | tail]) do
    reversed = nreverse(tail)
    [head] ++ reversed
  end

  # Initialize reverse function
  def reverse(list) do reverseFast(list, []) end

  # Reverse the list
  def reverseFast([], reversed) do reversed end
  def reverseFast([head | tail], reversed) do
    reverseFast(tail, [head | reversed])
  end

#-----------------------
# 6. More challenges
#-----------------------

#-----------------------
# 6.1 Integer to binary
#-----------------------

  def to_binary(0) do [] end
  def to_binary(n) do
    to_binary( div(n - rem(n , 2), 2) ) ++ [rem(n, 2)]
  end

  def to_better(n) do to_better(n, []) end
  def to_better(0, b) do b end
  def to_better(n, b) do
    to_better(div(n, 2), [rem(n, 2) | b])
  end

#-----------------------
# 6.2 Binary to integer
#-----------------------

  def to_integer(x) do to_integer(x, 0) end
  def to_integer([], n) do n end
  def to_integer([x | r], n) do
    to_integer(r , n + product( rem(x, 2), exp(2, length(r)) ) )
  end

#-----------------------
# 6.2 Fibonacci
#-----------------------

  def fib(0) do 0 end
  def fib(1) do 1 end
  def fib(n) do fib(n - 1) + fib(n - 2) end

end
