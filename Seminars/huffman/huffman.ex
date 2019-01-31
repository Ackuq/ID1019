defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end
  def sampleSmall do
    'voodoo'
  end
  def text() do
    'this is something that we should encode'
  end
  def testSmall do
    sample = sampleSmall()
    tree = tree(sample)
    encode = encode_table(tree)
    seq = encode(sample, encode)
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


  def build_tree([{tree, _}]) do tree end
  def build_tree([{a, a_freq}, {b, b_freq} | rest]) do
    build_tree( insert({ {a, b}, a_freq + b_freq }, rest))
  end

  def insert({a, a_freq}, []) do [{a, a_freq}] end
  def insert({a, a_freq}, [{b, b_freq} | rest]) when a_freq < b_freq do
      [{a, a_freq}, {b, b_freq} | rest]
  end
  def insert({a, a_freq}, [{b, b_freq} | rest]) do
    [{b, b_freq} | insert({a, a_freq}, rest)]
  end

  # Create encoding table
  def encode_table(tree) do
    codes(tree, [])
  end

  def codes({a, b}, travel) do
    as = codes(a, [0 | travel])
    bs = codes(b, [1 | travel])
    as ++ bs
  end
  def codes(a, code) do
    [{a, Enum.reverse(code)}]
  end


  # return value if key is found, else return :no
  def lookup(_, []) do [] end
  def lookup(char, [{char, code} | rest]) do code end
  def lookup(char, [{ _, _ }  | rest]) do
    lookup(char, rest)
  end

  # Encode the text using the table, return seq. of bits
  def encode([], _) do [] end
  def encode([char | rest], table) do
    lookup(char, table) ++ encode(rest, table)
  end

  # Create decoding table containing
  def decode_table(tree) do codes(tree, []) end

  # Decode seq. using the mapping table, return text
  def decode([], _) do
    []
  end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end
  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, _} ->
        {char, rest}
      nil ->
        decode_char(seq, n+1, table)
    end
  end
end
