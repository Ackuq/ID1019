defmodule HingesMemory do

  ## Hur reducerar vi ett problem i mindre delar
  ## så att vi kommer närma en lösning.
  ## Minnen är ett sätt!

  def search(m, t, {hm, ht, hp}=h, {lm, lt, lp}=l, mem)  when (m >= hm) and
      (t >= ht) and
      (m >= lm) and
      (t >= lt) do
    {{hi, li, pi}, mem} = check((m-hm), (t-ht), h, l, mem)
    {{hj, lj, pj}, mem} = check((m-lm), (t-lt), h, l, mem)
    if (pi + hp) > (pj + lp) do
      {{(hi+1), li, (pi+hp)}, mem}
    else
      {{hj, (lj+1), (pj+lp)}, mem}
    end
  end

  def search(m, t, {hm, ht, hp}=h, l, mem) when (m >= hm) and (t >= ht) do
    ## we can make a hinge
    {{hn, ln, p}, mem} = check((m-hm), (t-ht), h, l, mem)
    {{hn+1, ln, (p+hp)}, mem}
  end
  def search(m, t, h, {lm, lt, lp}=l, mem) when (m >= lm) and (t >= lt) do
    ## we can make a latch
    {{hn, ln, p}, mem} = check((m-lm), (t-lt), h, l, mem)
    {{hn, ln+1, p+lp}, mem}
  end
  def search(_, _, _, _, mem) do
    ## we can make neither
    {{0,0,0}, mem}
  end

  def memory(material, time, hinge, latch) do
    mem = Memory.new()
    {solution, _} = search(material, time, hinge, latch, mem)
    solution
  end

  def check(material, time, hinge, latch, mem) do
    case Memory.lookup({material, time}, mem) do
      nil ->
        ## No previus
        {solution, mem} = search(material, time, hinge, latch, mem)
        {solution, Memory.store({material, time}, solution, mem)}
      found ->
        {found, mem}
    end
  end

end
