defmodule Env do


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


  @spec new() :: []
  def new() do [] end

  @spec add(id, str, env) :: env
  def add(id, str, env) do
    [{id, str} | env]
  end

  @spec lookup(id, env) :: {id, str} | nil
  def lookup(_, []) do nil end
  def lookup(id, [{id, str} | _]) do {id, str} end
  def lookup(id ,[_ | rest ]) do lookup(id, rest) end

  @spec remove([id], env) :: env
  def remove([], env) do env end
  def remove([id | rest], env) do
    remove(rest, removeID(id, env))
  end

  @spec removeID(id, env) :: env
  def removeID(_, []) do [] end
  def removeID(id, [{id, _} | rest]) do removeID(id, rest) end
  def removeID(id, [ head | rest]) do [head | removeID(id, rest)] end

  @spec closure([variable], env) :: env | :error
  def closure(ids, env) do
    List.foldr(ids, [], fn id, acc ->
      case acc do
        :error ->
          :error

        cls ->
          case lookup(id, env) do
            {id, value} ->
              [{id, value} | cls]

            nil ->
              :error
          end
      end
    end)
  end


  @spec args([variable], [str], env) :: env
  def args(par, strs, env) do
    List.zip([par, strs]) ++ env
  end
end
