defmodule Lists do

  def take([h | _], 1) do [h] end
  def take([h | t], n) do [h | take(t, n - 1)] end

  def drop([_ | t], 1) do t end
  def drop([_ | t], n) do drop(t, n - 1) end

  def append(x, y) do x ++ y end

  def member([], _) do :no end
  def member([x | _], x) do :yes end
  def member([_ | t], x) do member(t, x) end

  def position([x | _], x) do 1 end
  def position([_ | t], x) do
    1 + position(t, x)
  end

end
