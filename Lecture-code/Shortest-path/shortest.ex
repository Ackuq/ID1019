defmodule Shortest do

  ## If we are in final node
  def shortest(from, from, _) do {0, []} end

  # Otherwise, find the shorest path from the reached node
  # and return the shortest given distance to the
  def shortest(from, to, graph) do
    next = Graph.next(from, graph)
    distances = distances(next, to, graph)
    select(distances)
  end

  def distances(next, to, graph) do
    Enum.map(next, fn({n,d}) ->
      case shortest(n, to, graph) do
        {:inf, nil} -> {:inf, nil}
        {k, path} -> {d+k, [n|path]}
      end
    end)
  end

  # Select shorest path from list
  def select(distances) do
    List.foldl(distances,
     {:inf, nil},
     fn ({d,_} = s, {ad, _} = acc) ->
       if d < ad do
         s
       else
         acc
       end
     end)
  end
end
