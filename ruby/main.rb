require 'yaml'
require_relative './analisador_lexico/Analyzer.rb'

scan = Analyzer.new(YAML.load_file(File.join(__dir__, './analisador_lexico/rules.yml')))
# scan.ignore_tokens = 'COMMENT'
# scan.errors = true
p = scan.tokenizer_file('./analisador_lexico/teste.nsp')

p.each{|d| puts "[#{d[:line] }]#{d[:type] } => #{d[:value] }"}
