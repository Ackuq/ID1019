defmodule Eager do

  @type atm :: {:atm, atom()}
  @type variable :: {:var, atom()}

  @type cons(e) :: {:cons, e, e}

  @type expr :: atm | variable | lambda | cons(expr)
  @type ignore :: :ignore

  @type pattern :: atm | variable | ignore | cons(pattern)

  @type id :: atom()
  @type str :: any()

  @type env :: [{id, str}]

  @type match :: {:match, pattern, expr}

  @type lambda :: {:lambda, [variable], [variable], seq}
  @type seq :: [expr] | [match | seq]
  @type closure :: {:closure, [variable], seq, env}

  @type case :: {:case, expr, [clause]}
  @type clause :: {:clause, pattern, seq}
  @type apply :: {:apply, expr, [variable]}

  @spec eval_cls(str, [clause], env) :: {:ok, str} | :error
  def eval_cls([], _, _, _) do :error end
  def eval_cls([{:clause, ptr, seq } | cls], str, env) do
    vars = extract_vars(ptr)
    env  = Env.remove(vars, env)
    case eval_match(ptr, str, env) do
      :fail ->
        eval_cls(cls, str, env)
      {_, env} ->
        eval_seq(seq, env)
    end
  end

  # eval_expr takes an expression and evaluates it
  @spec eval_expr(expr, env) :: {:ok, id} | :error
  def eval_expr({:apply, expr, args}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, {:closure, par, seq, closure}} ->
        case eval_args(args, env) do
          :error ->
            :error
          strs ->
            env = Env.args(par, strs, closure)
            eval_seq(seq, env)
        end
    end
  end
  def eval_expr({:case, expr, cls}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {_, str} ->
        eval_cls(cls, str, env)
    end
  end
  def eval_expr({:lambda, par, free, seq}, env) do
    case Env.closure(free, env) do
      :error ->
        :error
      closure ->
        {:ok, {:closure, par, seq, closure}}
    end
  end
  # If we evaluate atom, its mapped to itself
  def eval_expr({:atm, id}, _) do {:ok, id} end
  # We need to check if the variable is in the enviroment, then check what value it is mapped to
  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil ->
        :error
      {_, str} ->
        {:ok, str}
    end
  end
  # Evaluate each expression
  def eval_expr({:cons, he, te}, env) do
    case eval_expr(he, env) do
      :error ->
        :error
      {:ok, hs} ->
        case eval_expr(te, env) do
          :error ->
            :error
          {:ok, ts} ->
            {:ok, [hs | ts]}
      end
    end
  end

  # Match a pattern with a data structure
  @spec eval_match(pattern, expr, env) :: {:ok, env} | :fail
  def eval_match(:ignore, _, env) do
    {:ok, env}
  end
  def eval_match({:atm, id}, id, env) do
    {:ok,  env}
  end
  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
      nil ->
        {:ok, Env.add(id, str, env)}
      {_, ^str} ->
        {:ok, env}
      {_, _} ->
        :fail
    end
  end
  def eval_match({:cons, hp, tp}, [hs | ts], env) do
    case eval_match(hp, hs, env) do
      :fail ->
          :fail
      {:ok, env} ->
        eval_match(tp, ts, env)
    end
  end
  def eval_match( _,_,_) do
    :fail
  end

  # Initiation
  def eval(seq) do
    eval_seq(seq, Env.new())
  end

  # Evaluate a sequence of expressions
  @spec eval_seq([expr], env) :: {:ok, id} | :error
  def eval_seq([exp], env) do eval_expr(exp, env) end
  def eval_seq([{:match, pattern, exp} | rest], env) do
    case eval_expr(exp, env) do
      :error ->
        :error
      {:ok, str} ->
        vars = extract_vars(pattern)
        env = Env.remove(vars, env)

        case eval_match(pattern, str, env) do
          :fail ->
            :error
          {:ok, env} ->
            eval_seq(rest, env)
        end
    end
  end

  # Take a pattern and return list of variables
  @spec extract_vars(pattern) :: [variable] | []
  def extract_vars({:cons, p1, p2}) do extract_vars(p1) ++ extract_vars(p2) end
  def extract_vars({:var, var}) do [var] end
  def extract_vars(_) do [] end

  def eval_args([], _) do [] end
  def eval_args([expr | exprs], env) do
    case eval_expr(expr, env) do
      :error ->
        :error

      {:ok, str} ->
        case eval_args(exprs, env) do
          :error ->
            :error

          strs ->
            [str | strs]
        end
    end
  end

end
