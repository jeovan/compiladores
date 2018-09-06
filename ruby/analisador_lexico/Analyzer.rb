class Analyzer
  attr_accessor :rules
  def initialize(rules)
    @rules = rules
  end

  def tokenizer(characters, line = 0)
    tb_line =  Hash.new
    @rules.each do |k,t|
      characters.enum_for(:scan, t).map do |r|
        if tb_line.select {|chapter| chapter === Regexp.last_match.begin(0) || chapter === Regexp.last_match.end(0)}.empty?
          tb_line[Regexp.last_match.begin(0)..Regexp.last_match.end(0)-1] = {
              :line =>line,
              :value => r,
              :type => k,
              :pos_initial =>  Regexp.last_match.begin(0),
            }
        end
      end
    end
    tb_line = sort_hash(tb_line)
    tb_line = unknown_lexemes(tb_line,characters,line)
    return tb_line.values
  end

  def tokenizer_file(filename)
    tb = []
    File.open(filename, "r").each_line.with_index  do |line,index|
      tb.push(tokenizer(line,index))
    end
    return tb
  end

  def unknown_lexemes(tb_line,characters,line)
    unknown = []
    prev = 0
    unknown << (0..characters.length-1) if tb_line.length == 0
    tb_line.each do |k,v|
      if k == tb_line.keys.first
        unknown << (0..k.first-1) unless (k === 0)
      else
        unknown << (prev.last+1..k.first-1) if k.first > prev.last+1
        if k == tb_line.keys.last
          unknown << (k.last+1..characters.length-1) unless (k === characters.length-1)
        end
      end
      prev = k
    end
    unknown.each do |v|
      tb_line[v] = {:line =>line,:value => characters[v],:type => :UNKNOWN,:pos_initial =>  v.first} unless ((/^\s+$/=~ characters[v]))
    end
    tb_line = sort_hash(tb_line)
    return tb_line
  end

  def sort_hash(tb)
    return Hash[ tb.sort_by { |key, val| val[:pos_initial].to_i } ]
  end

end