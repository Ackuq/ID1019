defmodule ShortestDynamic do

  # Dynamic approach, add memory
  def dynamic(from, to, graph) do
    mem = Memory.new()
    {solution, _} = shortest(from, to, graph, mem)
    solution
  end

  def shortest(from, from, _ , mem) do
    {{0, []}, mem}
  end
  def shortest(from, to, graph, mem) do
    next = Graph.next(from, graph)
    {dist, mem} = distances(next, to, graph, mem)
    shortest = select(dist)
    {shortest, mem}
  end

  def distances(next, to, graph, mem) do
    List.foldl(next, {[], mem},
      fn({t, d}, {dis, mem} = acc) ->
        case check(t, to, graph, mem) do
          {{:inf, _}, _} ->
            acc
          {{n, path}, mem} ->
            {[{d+n, [t | path]}| dis], mem}
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

  # If a solution exists use it, if not - compute it.
  def check(from, to, graph, mem) do
    case Memory.lookup(from, mem) do
      nil ->
        {solution, mem} = shortest(from, to, graph, mem)
        {solution, Memory.store(from, solution, mem)}
      solution ->
        {solution, mem}
    end
  end

end
