defmodule Test do
  def test() do
    array = Memory.new([:a,:b,:c,:d,:e,:f,:g,:h])
    Memory.write(array, 5, :foo)
    Memory.write(array, 2, :bar)
    Memory.readAll(array)
  end
end
