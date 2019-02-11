defmodule Sphere do

  @color {1.0, 0.4, 0.4}

  defstruct pos: {0, 0, 0}, radius: 2, color: @color

  defimpl Object do

    # If intesect return {:ok, d}, else return :no
    def intersect(sphere = %Sphere{}, ray = %Ray{}) do
      k = Vector.sub(sphere.pos, ray.pos)
      a = Vector.dot(k, ray.dir)
      a2 = a * a
      k2 = Vector.norm(k) * Vector.norm(k)
      r2 = sphere.radius * sphere.radius
      t2 = a2 - k2 + r2
      if t2 < 0 do
        :no
      else
        t = :math.sqrt(t2)
        calcDistance(t, a)
      end
    end

    defp calcDistance(t, a) do
      d1 = a - t
      d2 = a + t
      cond do
        d1 > 0.0 and d2 > 0.0 ->
          {:ok, min(d1, d2)}
        d1 > 0.0 ->
          {:ok, d1}
        d2 > 0.0 ->
          {:ok, d2}
        true ->
          :no
      end
    end
  end
end
