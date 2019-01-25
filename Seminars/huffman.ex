defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end
  def sampleSmall do
    'aaabbd'
  end
  def text() do
    'this is something that we should encode'
  end
  def testSmall do
    sample = sampleSmall()
    tree = tree(sample)
  end
  def test do
    sample = sample()
    tree = tree(sample)
    #encode = encode_table(tree)
    #decode = decode_table(tree)
    #text = text()
    #seq = encode(text, encode)
    #decode(seq, decode)
  end

  # Check the frequency of characters
  def freq(sample) do freq(sample, []) end
  def freq([], freq) do freq  end
  def freq([char | rest], freq) do
    freq(rest, count(char, freq) )
  end

  # If character is found, +1 frequency
  def count(char, []) do [{char , 1}] end
  def count(char, [{char, n} | freq]) do [{char, n + 1} | freq] end
  def count(char, [elem | freq]) do [elem | count(char, freq)] end

  # Create tree
  def tree(sample) do
    freq = freq(sample)
    sorted = Enum.sort(freq, fn({_, x}, {_, y}) -> x < y  end)
    build_tree(sorted)
  end

  # Connect each node
  def build_tree([{tree, _}]) do tree end
  def build_tree([{a, a_freq}, {b, b_freq} | rest]) do
    build_tree(insert({{a, b}, a_freq + b_freq}, rest)))
  end

  def insert({a, a_freq}, []) do [{a, a_freq}] end
  def insert({a, a_freq}, [{b, b_freq} | rest]) when a_freq < b_freq do
    [{a, a_freq} | insert({b, b_freq}, rest)]
  end
  def insert({a, a_freq}, [{b, b_freq} | rest]) do
    [{b, b_freq} | insert({a, a_freq}, rest)]
  end

  # Create encoding table
  def encode_table(tree) do
  end

  # Create decoding table containing
  def decode_table(tree) do
  # To implement...
  end

  # Encode the text using the table, return seq. of bits
  def encode(text, table) do
  # To implement...
  end

  # Decode seq. using the mapping table, return text
  def decode(seq, tree) do
  # To implement...
  end
end
