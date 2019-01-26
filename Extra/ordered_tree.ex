defmodule OrderedTree do

  # https://people.kth.se/~johanmon/courses/id1019/lectures/trees.pdf

  def init(key, val) do
    {:node, key, val, :nil, :nil}
  end

  def member(_, :nil) do :no end
  def member(key, {:node, key, _, _, _}) do :yes end
  def member(key, {:node, k, _, left, right}) do
    if key < k do
      member(key, left)
    else
      member(key, right)
    end
  end


  # Add element to tree
  def insert(key, value, :nil) do {:node, key, value, :nil, :nil} end
  def insert(key, value, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, insert(key, value, left), right}
    else
      {:node, k, v, left, insert(key, value, right)}
    end
  end

  # Get the minimum node from root
  def minValueNode({:node, key, value, :nil, _})do
    [key, value]
  end
  def minValueNode({:node, _,_, left, _}) do
    minValueNode(left)
  end

  # Delete the node with key 'key'
  def delete(key, {:node, key, _, :nil, :nil}) do :nil end
  def delete(key, {:node, key, _, :nil, right}) do right end
  def delete(key, {:node, key, _, left, :nil}) do left end
  # Node with two children: Get the inorder successor
  def delete(key, {:node, key, _, left, right }) do
    [k | [v | _]] = minValueNode(right)
    {:node, k, v,  left, delete(k, right)}
  end
  def delete(key, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, delete(key, left), right}
    else
      {:node, k, v, left, delete(key, right)}
    end
  end
end
