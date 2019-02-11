defmodule Tracer do

  @black {0, 0, 0}
  @white {1, 1, 1}

  def tracer(camera, objects) do
    {w, h} = camera.size
    for y <- 1..h, do: for(x <- 1..w, do: trace(x, y, camera, objects))
  end

  def trace(x, y, camera, objects) do
    ray = Camera.ray(camera, x, y)
    trace(ray, objects)
  end

  def trace(ray, objects) do
    case intersect(ray, objects) do
      {:inf, _} ->
        @black
      {_, _} ->
        object.color
    end
  end

  def trace_light(ray, world) do
    objects = world.objects
    case intersect(ray, objects) do
      {:inf, _} ->
        world.background
      {dist, obj} ->
        pos = ray.pos
        dir = ray.direction
        point = Vector.add(pos, Vector.smul(dir, dist - @delta))
        normal = Sphere.normal(point, obj)
        visible = visible(point, world.lights, objects)
        illumination = Light.combine(point, normal, visible)
        Light.illuminate(obj, illumination, world)
    end
  end

  def intersect(ray, objects) do
    List.foldl(objects, {:inf, nil}, fn(object, sofar) ->
      {dist, _} = sofar

      case Object.intersect(object, ray) do
        {:ok, d} when d < dist ->
          {d, object}
        _ ->
          sofar
      end
    end)
  end
end
