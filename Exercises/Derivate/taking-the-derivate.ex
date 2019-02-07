defmodule Derivate do
  #------------------
  # Taking the derivate
  #------------------

  # Literals are constans and variables
  @type literal() :: {:const, number()} | {:const, atom()} | {:var, atom()}
  # Expressions are tuples
  @type expr() :: {:add, expr(), expr()} | {:mul, expr(), expr()} | literal()

  @spec deriv(expr(), literal()) :: expr()


  def test() do
      test =
        {:add, {:mul, {:ln, {:var, :x}}, {:pow, {:var, :x}, {:const, 2}}},
         {:add, {:mul, {:const, 3}, {:var, :x}}, {:const, 42}}}

      der = deriv(test, :x)
      simp = simplify(der)
      printExp(test)
      IO.write("\n")
      printExp(der)
      IO.write("\n")
      printExp(simp)
      IO.write("\n")
    end

  #------------------
  # Derivation definitions
  #------------------

  # constant -> 0
  def deriv({:const, _}, _) do {:const, 0} end
  # x -> 1
  def deriv({:var, x}, x) do {:const, 1} end
  # y -> y
  def deriv({:var, y}, _) do {:var, y} end
  # f1(x) * f2(x) -> f1'(x) *f2(x) + f1(x) * f2'(x)
  def deriv({:mul, e1, e2}, x) do
     {:add, {:mul, deriv(e1, x), e2}, {:mul, e1, deriv(e2, x)}}
  end
  # f1(x) + f2(x) -> f2'(x) + f2'(x)
  def deriv({:add, e1, e2}, x) do
    {:add, deriv(e1, x), deriv(e2, x)}
  end
  # x^n = n*x^(n-1)
  def deriv({:pow, {:var, x}, {:const, n}}, x) do
    {:mul, {:const, n}, { :pow, { :var, x }, {:const, n - 1}}}
  end
  # ln(x) -> 1/x
  def deriv({:ln, {:var, x}}, x), do: {:div, {:const, 1}, {:var, x}}
  # 1/x  -> .-1/(x^2)
  def deriv({:div, {:var, x}}, x), do: {:div, {:const, -1}, {:pow, {:var, x}, {:const, 2}}}
  # 1/(x^n) -> -n/(x^(n+1))
  def deriv({:div, {:pow, {:var, x}, {:const, n} } }, x), do: {:div, {:const, -n}, {:pow, {:var, x}, {:add,{:const, n}, {:const, 1}}}}
  # sqrt(x) -> 1/(2*sqrt(x))
  def deriv({:sqrt, {:var, x}}, x), do: {:div, {:const, 1}, {:mul, {:const, 2}, {:sqrt, {:var, x }}}}
  # sqrt(n*x) -> n/(2*sqrt(n*x))
  # Add function here
  # sin(x) -> cos(x)
  def deriv({:sin, {:var, x}}, x), do: {:cos, {:var, x}}
  # sin(n*x) -> n*cos(n*x)
  def deriv({:sin,  {:mul, {:const, n}, {:var, x}}}, x), do: {:mul, {:const, n}, {:cos, {:mul, {:const, n}, {:var, x}}}}

  #------------------
  # Simplify expressions
  #------------------

  def simplify({:const, c}) do {:const, c} end
  def simplify({:var, v}) do {:var, v} end
  def simplify({:pow, e1, e2}) do
    case simplify(e2) do
      {:const, 0} ->
        {:const, 1}

      {:const, 1} ->
        simplify(e1)

      simp2 ->
        case simplify(e1) do
          {:const, 0} ->
            {:const, 0}

          {:const, 1} ->
            {:const, 1}

          simp1 -> {:pow, simp1, simp2}
        end
    end
  end
  def simplify({:mul, e1, e2}) do
    case simplify(e1) do
      {:const, 0 } ->
        {:const, 0}

      {:const, 1} ->
        simplify(e2)

      simp1 ->
        case simplify(e2) do
          {:const, 0} ->
            {:const, 0}

          {:const, 1} ->
            simp1

          simp2 ->
            {:mul, simp1, simp2}
        end
    end
  end

  def simplify({:add, e1, e2}) do
    case simplify(e1) do
      {:const, 0} ->
        simplify(e2)

      simp1 ->
        case simplify(e2) do
          {:const, 0 } ->
            simp1
          simp2 ->
            {:add, simp1, simp2}
        end
    end
  end

  # Simplify e1/e2
  def simplify({:div, e1, e2}) do
    case simplify(e1) do
      {:const, 0} ->
        {:const, 0}
      simp1 ->
        {:div, simp1, simplify(e2)}
    end
  end

  #simplify 1/e
  def simplify({:div, e}) do {:div, simplify(e)} end

  # Simplify ln(e)
  def simplify({:ln, e}) do {:ln, simplify(e)} end

  # simplify square root
  def simplify({:sqrt, e}) do
    case simplify(e) do
      {:const, 0} ->
        {:const, 0}
      {:const, 1} ->
        {:const, 1}
      simp ->
        {:sqrt, simp}
    end
  end

  # Simplify sin and cos
  def simplify({:sin, e}) do {:sin, simplify(e)} end
  def simplify({:cos, e}) do {:cos, simplify(e)} end

  #------------------
  # Format the expressions
  #------------------

  def printExp({:const, c}) do IO.write("#{c}") end
  def printExp({:var, v}) do IO.write("#{v}") end

  # e1^e2
  def printExp({:pow, e1, e2}) do
    printExp(e1)
    IO.write("^")
    printExp(e2)
  end
  # (e1 * e2)
  def printExp({:mul, e1, e2}) do
    IO.write('(')
    printExp(e1)
    IO.write(" * ")
    printExp(e2)
    IO.write(')')
  end

  # e1 + e2
  def printExp({:add, e1, e2}) do
    printExp(e1)
    IO.write(" + ")
    printExp(e2)
  end
  # 1/e
  def printExp({:div, e}) do
    printExp('1')
    IO.write('/')
    printExp(e)
  end

  # e1/e2
  def printExp({:div,e1, e2}) do
    printExp(e1)
    IO.write("/")
    printExp(e2)
  end

  # ln(e)
  def printExp({:ln, e}) do
      IO.write("ln(")
      printExp(e)
      IO.write(')')
  end

  # sqrt(e)
  def printExp({:sqrt, e}) do
      IO.write("sqrt(")
      printExp(e)
      IO.write(')')
  end
  def printExp({:sin, e}) do
      IO.write("sin(")
      printExp(e)
      IO.write(')')
  end
  def printExp({:cos, e}) do
      IO.write("cos(")
      printExp(e)
      IO.write(')')
  end
end
