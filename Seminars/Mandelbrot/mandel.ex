defmodule Mandel do

  def demo() do
    small(-2.6, 1.2, 1.2)
  end

  def small(x0, y0, xn) do
    width = 960
    height = 540
    depth = 64
    k = (xn - x0) / width
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("small.ppm", image)
  end

  # x + xi is the upper left corner
  # k = offset between two points
  # width and height is the size of image
  def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) ->
      Cmplx.new(x + k * (w - 1), y - k * (h - 1))
    end
    rows(width, height, trans, depth, [])
  end

  # first pixel of upper row the depth of
  # x + yi, (x + k) + yi, (x + 2k) + yi
  # Second row start with x + (y − k)i
  def rows(_, 0, _, _, rows) do rows end
  def rows(width, height, trans, depth, rows) do
    rows(width, height - 1, trans, depth, [row(width, height, trans, depth, []) | rows])
  end

  def row(0, _, _, _, row) do row end
  def row(width, height, trans, depth, row) do
    color = Colors.convert(Brot.mandelbrot(trans.(width, height), depth), depth)
    row(width - 1, height, trans, depth, [color | row])
  end

end
