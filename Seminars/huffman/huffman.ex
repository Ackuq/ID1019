defmodule Huffman do
  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end
  def text() do
    'this is something that we should encode'
  end
  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)
    decode(seq, decode)
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
  def encode_table(tree) do codes(tree, [], []) end

  def codes({a, b}, travel, acc) do
    left  = codes(a, [0 | travel], acc)
    codes(b, [1 | travel], left)
  end
  def codes(a, code, acc) do [{a, Enum.reverse(code)} | acc] end


  # return value if key is found, else return :no
  def lookup(_, []) do [] end
  def lookup(char, [{char, code} | _]) do code end
  def lookup(char, [{ _, _ }  | rest]) do lookup(char, rest) end

  # Encode the text using the table, return seq. of bits
  def encode([], _) do [] end
  def encode([char | rest], table) do lookup(char, table) ++ encode(rest, table) end

  # Create decoding table containing
  def decode_table(tree) do codes(tree, [], []) end

  # Decode seq. using the mapping table, return text
  def decode([], _) do [] end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case charFind(table, code) do
      {char, _} -> {char, rest}
      nil -> decode_char(seq, n+1, table)
    end
  end

  # Find the character
  def charFind([], _) do nil end
  def charFind([{char, code} | _], code) do {char, code} end
  def charFind([ _ | rest ], code) do
    charFind(rest, code)
  end


#---------
# This code is available on the courses GitHub
# https://github.com/ID1019/functional-programming/blob/master/exercises/huffman/src/huffman.ex
#---------
  # Read file
  def read(file, n) do
    {:ok, file} = File.open(file, [:read])
    binary = IO.read(file, n)
    File.close(file)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} ->
        list;
      list ->
        list
    end
  end

  def kallocain(n, coding) do
   {:ok, file} = File.open("kallocain.txt", [:read])
   binary = IO.read(file, n)
   File.close(file)

   length = byte_size(binary)
   character_decode(binary, length, coding)
 end

  # Several character encodings are available:
  # - latin1 will force to read one byte at a time
  # - utf8 will read the content character by character
  #   where a character might be two bytes (or more). The
  #   characters: å, ä and ö are two bytes.
  # - utf16 will read the content two bytes at a time
  #   (possibly more).
  # - utf24 is a faked coding scheme that will simply read
  #   three bytes at a time.
  def character_decode(binary, length, :latin1) do
    {:binary.bin_to_list(binary), length}
  end
  def character_decode(binary, length, :utf8) do
    {:unicode.characters_to_list(binary, :utf8), length}
  end
  def character_decode(binary, length, :utf16) do
    case :unicode.characters_to_list(binary, :utf16) do
      {:incomplete, list, rest} ->
        {list, length - byte_size(rest)}

      list ->
        {list, length}
    end
  end

  # This is the benchmark of the single operations in the
  # Huffman encoding and decoding process.
  def bench(n, coding) do
    {sample, _} = kallocain(n, coding)
    {{text, b}, t1} = time(fn -> kallocain(n, coding) end)
    c = length(text)
    {tree, t2} = time(fn -> tree(sample) end)
    {encode, t3} = time(fn -> encode_table(tree) end)
    s = length(encode)
    {decode, _} = time(fn -> decode_table(tree) end)
    {encoded, t5} = time(fn -> encode(text, encode) end)
    e = div(length(encoded), 8)
    r = Float.round(e / b, 3)
    {_, t6} = time(fn -> decode(encoded, decode) end)

    IO.puts("read in #{t1} ms")
    IO.puts("text of #{c} characters")
    IO.puts("tree built in #{t2} ms")
    IO.puts("table of size #{s} in #{t3} ms")
    IO.puts("encoded in #{t5} ms")
    IO.puts("decoded in #{t6} ms")
    IO.puts("source #{b} bytes, encoded #{e} bytes, compression #{r}")
  end

  # Measure the execution time of a function.
  def time(func) do
    initial = Time.utc_now()
    result = func.()
    final = Time.utc_now()
    {result, Time.diff(final, initial, :microsecond) / 1000}
  end
end
