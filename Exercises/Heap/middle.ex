defmodule Middle do

  def start() do spawn(fn() -> empty()) end

  def empty() do
    receive do
      {:add, v} ->
        left = Cheap.new(fn(x,y) -> x < y end)
        right = Cheap.new(fn(x, y) -> x > y end)
        left(v, left, right)
      {:get, pid} ->
        send(pid, :fail)
        empty
    end
  end

  def  left(m, left, right) do
    receive do
      {:add, v} when v < m ->
        {:ok, k, swaped} = Heap.swap(left, v)
        right(k, swaped, Heap.add(right, m))
      {:add, v} ->
        right(m, left, Heap.add(right, v))
      {:get, pid} ->
        send(pid, {:ok, m})
        case Heap.pop(left) do
        
          {:ok, k, rest} ->
            right(k, rest, right)
          :fail ->
            empty()
          end
        end
  end

end
