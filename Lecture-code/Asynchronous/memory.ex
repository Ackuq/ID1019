defmodule Memory do

  def new(list) do
    cells = Enum.map(list, fn(v) -> Cell.start(v) end)
    {:mem, List.to_tuple(cells)}
  end

  def read({:mem, mem}, n) do
    Cell.read(elem(mem, n))
  end

  def write({:mem, mem}, n, val) do
    Cell.write(elem(mem, n), val)
  end

  def delete({:mem, mem}) do
    Enum.each(Tuple.to_list(mem), fn(c) -> Cell.quit(c) end)
  end

  def readAll({:mem, mem}) do
    Enum.each(Tuple.to_list(mem), fn(c) ->
      IO.write(Cell.read(c))
      IO.write('\n')
    end)
  end
end
