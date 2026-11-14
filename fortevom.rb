# frozen_string_literal: true

require_relative 'lexer'
require_relative 'parser'


command         = ARGV[0]
file_given      = ARGV[1]
output_language = ARGV[2]

unless %w[lex parse compile transpile render digest].include? command
  if command =~ %r{(\w+)?/(\w+)}
    abort "Looks like you forgot to add a command. Remember to include a command before your file like 'compile'."
  end

  if [nil, ''].include? command
    puts 'You must provide a command.'
    puts 'If you want to compile a file, then use the compile command:'
    abort 'compile <input> <language>'
  else
    abort "Invalid command: #{command}"
  end
end

abort 'You must provide a file.' if file_given.nil?

# lex doesn't require an output language because the lexer is language-agnostic.
abort 'You must provide an output language.' if output_language.nil? && command != 'lex'

unless %w[cs php].include? output_language.chomp
  abort "Invalid output language provided: #{output_language}. Only use 'cs' to output C# or 'php' to output PHP."
end

def write(snippet, to:)
  # puts "WRITING"
  # puts "SNIPPET:"
  # puts snippet
  # puts "FILE:"
  # puts file_to_write_to

  snippet = "#{snippet}\n"

  begin
    File.write(to, snippet, mode: 'a')
  rescue StandardError => e
    puts "An exception was raised whilst trying to write to #{to}: #{e}"
  end
end

def compile(file, into:)
  # fail "The file given — #{file} — does not have the .fortevom extension." unless File.extname(file) == ".fortevom"

  parser = Parser.new

  file_to_write_to = if into == 'php'
                       "#{File.basename(file)}.php"
                     else
                       "#{File.basename(file)}.cs"
                     end

  lines = get_lines from: file
  line_number = 0 # a rough approximate as it will be skewed if you have multiple expressions on one line

  lines.each do |line|
    line_number += 1
    if line == ' '
      write "\n", to: file_to_write_to
      next
    end

    expressions = get_expressions from: line

    # puts "expressions:"
    # expressions.each {|expression| puts expression}

    expressions.each do |expression|
      next if expression == ' '

      token = lex expression

      # puts "token:"
      # pp token

      snippet = parser.parse(token, into, line_number)

      # puts "snippet:"
      # pp snippet

      write snippet, to: file_to_write_to
    end
  end
  file_to_write_to
end

def only_lex(file)
  lines = get_lines from: file
  tokens = []

  lines.each do |line|
    token = lex line
    tokens << token
  end

  puts "TOKEN OUTPUT OF #{file}:"
  tokens.each { |token| puts token }
end

def only_parse(file, with:)
  lines  = get_lines from: file
  tokens = []

  lines.each do |line|
    token = lex line
    tokens << token
  end

  line_number = 1
  snippets    = []

  tokens.each do |token|
    snippet = parse token, with, line_number
    snippets << snippet
    line_number += 1
  end

  puts "CODE SNIPPETS GENERATED FROM #{file} IN #{with}:"
  snippets.each { |snippet| puts snippet }
end

def orchestrate(file_given, output_language)
  output_file = compile file_given, into: output_language

  puts "Perfect! Your new file is named #{output_file}."
end

case command
when 'transpile', 'render', 'digest' then orchestrate file_given, output_language
when 'lex'                           then only_lex file_given
when 'parse'                         then only_parse file_given, with: output_language
else
  abort "Invalid command: #{command}"
end

# test command:
# ruby fortevom.rb digest tests/fortevom_test.txt php
