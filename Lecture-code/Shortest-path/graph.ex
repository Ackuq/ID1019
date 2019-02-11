defmodule Graph do

  def sample() do
    new([a: [b: 2, d: 5], b: [c: 2, e: 3], c: [e: 6, g: 1], d: [c: 3, f: 2], e: [g: 2], f: [c: 1, g: 3] ])
  end

  def new(nodes) do
    Map.new(nodes)
  end

  def next(from, map) do
    Map.get(map, from, [])
  end

end
