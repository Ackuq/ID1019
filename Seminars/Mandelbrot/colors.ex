defmodule Colors do

  @type color :: {:rgb, 0..255, 0..255, 0..255}

  @spec convert(number, number) :: color
  def convert(depth, max) when depth > max do {:error, "Depth > max"} end
  def convert(depth, max) do
    a = (depth / max) * 4
    x = trunc(a)
    y = round((255) * (a - x))
    case x do
      0 -> {:rgb, y, 0, 0}
      1 -> {:rgb, 255, y, 0}
      2 -> {:rgb, 255 - y, 255, 0}
      3 -> {:rgb, 0, 255, y}
      _ -> {:rgb, 0, 255-y, 255}
    end

  end

end
