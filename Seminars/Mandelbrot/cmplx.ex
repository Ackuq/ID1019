defmodule Cmplx do

  @type complex :: {:cmplx, number, number}

  @spec new(number, number) :: complex
  def new(real, im) do
    {:cmplx, real, im}
  end

  @spec add(complex, complex) :: complex
  def add({:cmplx, r1, i1}, {:cmplx, r2, i2}) do
    {:cmplx, r1 + r2, i1 + i2}
  end

  @spec sqr(complex) :: complex
  def sqr({:cmplx, real, im}) do
    {:cmplx, real*real-im*im, 2*real*im}
  end

  @spec abs(complex) :: number
  def abs({:cmplx, real, im}) do
    :math.sqrt(real * real + im * im)
  end

end
