class Analyzer
  attr_accessor :rules
  def initialize(rules)
    @rules = rules
  end

  def tokenizer(characters, line = 0)
    tb =  Hash.new
    @rules.each do |k,t|
      characters.enum_for(:scan, t).map do |r|
        if tb.select {|chapter| chapter === Regexp.last_match.begin(0) || chapter === Regexp.last_match.end(0)}.empty?
            tb[Regexp.last_match.begin(0)..Regexp.last_match.end(0)-1] = {
              :line =>line,
              :value => r,
              :type => k,
              :pos_initial =>  Regexp.last_match.begin(0),
            }
          end
      end
    end
    tb = sort_hash(tb)
    tb = unknown_lexemes(tb,characters,line)
    return tb.values
  end

  def tokenizer_file(filename)
    tb = []
    File.open(filename, "r").each_line.with_index  do |line,index|
      tb.push(tokenizer(line,index))
    end
    return tb
  end

  def unknown_lexemes(tb,characters,line)
    unknown = []
    prev = 0
    tb.each do |k,v|
      if k == tb.keys.first
        unknown << (0..k.first-1) unless (k === 0)
      else
        unknown << (prev.last+1..k.first-1) if k.first > prev.last+1
        if k == tb.keys.last
          unknown << (k.last+1..characters.length-1) unless (k === characters.length-1)
        end
      end
      prev = k
    end
    unknown.each do |v|
      tb[v] = {
        :line =>line,
        :value => characters[v],
        :type => :UNKNOWN,
        :pos_initial =>  v.first,
      }
    end
    tb = sort_hash(tb)
    return tb
  end

  def sort_hash(tb)
    return Hash[ tb.sort_by { |key, val| val[:pos_initial].to_i } ]
  end

end