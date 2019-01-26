defmodule OrderedTree do

  # https://people.kth.se/~johanmon/courses/id1019/lectures/trees.pdf

  # Create new tree a key and a value
  def init(key, val) do
    {:node, key, val, :nil, :nil}
  end

  # Check if key exists in tree
  def member(_, :nil) do :no end
  def member(key, {:node, key, _, _, _}) do :yes end
  def member(key, {:node, k, _, left, right}) do
    if key < k do
      member(key, left)
    else
      member(key, right)
    end
  end

  # return value if key is found, else return :no
  def lookup(_, :nil) do :no end
  def lookup(key, {:node, key, value, _, _}) do {:value, value} end
  def lookup(key, {:node, k, _, left, right}) do
    if key < k do
      lookup(key, left)
    else
      lookup(key, right)
    end
  end

  # Add element to tree, traverse into the tree until you
  # find an empty spot
  def insert(key, value, :nil) do {:node, key, value, :nil, :nil} end
  def insert(key, value, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, insert(key, value, left), right}
    else
      {:node, k, v, left, insert(key, value, right)}
    end
  end

  # Get the minimum node from root, used when deleting elements
  def minValueNode({:node, key, value, :nil, _}) do
    # return a tuple with the key and value of the minimum value node
    {key, value}
  end
  def minValueNode({:node, _,_, left, _}) do
    minValueNode(left)
  end

  # Delete the node with key 'key'
  def delete(key, {:node, key, _, :nil, :nil}) do :nil end
  def delete(key, {:node, key, _, :nil, right}) do right end
  def delete(key, {:node, key, _, left, :nil}) do left end

  # Node with two children: Get the inorder successor of the right node
  def delete(key, {:node, key, _, left, right }) do
    {k, v} = minValueNode(right)
    {:node, k, v,  left, delete(k, right)}
  end
  def delete(key, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, delete(key, left), right}
    else
      {:node, k, v, left, delete(key, right)}
    end
  end

  # Modify an element
  def modify(_, _, :nil) do :nil end
  def modify(key, val, {:node, key, _, left, right}) do
    {:node, key, val, left, right}
  end
  def modify(key, val, {:node, k, v, left, right}) do
    if key < k do
      {:node, k, v, modify(key, val, left), right};
    else
      {:node, k, v, left, modify(key, val,right)}
    end
  end



  def printTree({:node, key, value, :nil, :nil}) do
    IO.write("{ key: #{key}, val: #{value} }")
  end
  def printTree({:node, key, value, :nil, right}) do
    IO.write("{ key: #{key}, val: #{value}, right -> ")
    printTree(right)
    IO.write('}')
  end
  def printTree({:node, key, value, left, :nil}) do
    IO.write("{ key: #{key}, val: #{value}, left -> ")
    printTree(left)
    IO.write('}')
  end
  def printTree({:node, key, value, left, right}) do
    IO.write("{ key: #{key}, val: #{value}, left -> ")
    printTree(left)
    IO.write(', right -> ')
    printTree(right)
    IO.write('}')
  end
end
