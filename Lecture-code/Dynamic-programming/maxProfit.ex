defmodule Hinges do

  # Product  = {material, time, prize}
  @type latch :: {integer, integer, integer}
  @type hinge :: {integer, integer, integer}

  # The search functio returns {#latches, #hinges, profit}
  @spec search(integer, integer, hinge, latch) :: {integer, integer, integer}

  def search(m, t, {hm, ht, hp}=h, {lm, lt, lp}=l) when (m >= hm) and
      (t >= ht) and
      (m >= lm) and
      (t >= lt) do
    ## we have material and time to make either a hinge or latch
    {hi, li, pi} = search((m-hm), (t-ht), h, l)
    {hj, lj, pj} = search((m-lm), (t-lt), h, l)
      ## which alternative will give us the maximum profit
    if (pi+hp) > (pj+lp) do
      ## make hinge
      {(hi+1), li, (pi+hp)}
    else
      # make a latch
      {hj, (lj+1), (pj+lp)}
    end
  end

  def search(m, t, {hm, ht, hp}=h, l) when (m >= hm) and (t >= ht) do
    ## we can make a hinge
    {hn, ln, p} = search((m-hm), (t-ht), h, l)
    {hn+1, ln, (p+hp)}
  end
  def search(m, t, h, {lm, lt, lp}=l) when (m >= lm) and (t >= lt) do
    ## we can make a latch
    {hn, ln, p} = search((m-lm), (t-lt), h, l)
    {hn, ln+1, p+lp}
  end
  def search(_, _, _, _) do
    ## we can make neither
    {0,0,0}
  end

end
