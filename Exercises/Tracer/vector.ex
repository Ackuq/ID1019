defmodule Vector do

  # Scalar mul.
  def smul({x1, x2, x3}, s) do
    {s * x1, s * x2, s * x3}
  end

  # Subtraction
  def sub({x1, x2, x3}, {y1, y2, y3}) do
    {x1-y1, x2-y2, x3-y3}
  end

  # Addition
  def add({x1, x2, x3}, {y1, y2, y3}) do
    {x1+y1, x2+y2, x3+y3}
  end

  # Dot prod.
  def dot({x1, x2, x3}, {y1, y2, y3}) do
    x1*y1 + x2*y2 + x3*y3
  end

  # Norm/length of vector
  def normalize(x) do
    smul(x, 1/norm(x))
  end

  # Normalize vector
  def norm({x1, x2, x3}) do
    :math.sqrt(x1 * x1 + x2 * x2 + x3 * x3)
  end
end
