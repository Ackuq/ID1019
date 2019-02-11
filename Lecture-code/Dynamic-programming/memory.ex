defmodule Memory do

  def new() do [] end

  def store(k, v , mem) do
    [{k, v} | mem]
  end

  def lookup(_, []) do nil end
  def lookup(k, [{k, v} | _]) do v end
  def lookup(k, [_| rest]) do lookup(k, rest) end

end
