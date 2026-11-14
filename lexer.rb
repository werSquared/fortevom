def get_lines(from:)
  unless File.exist? from
    abort "The given file doesn't exist in this context: #{from}"
  end

  lines = nil

  begin
    lines = File.readlines from
  rescue StandardError => e
    puts "Failed to read the file #{from}. Error: #{e}"
  end

  lines
end

# split each line by semicolons
def get_expressions(from:)
  from.split(';').map { |expr| expr.strip.split.join(' ') }
end

# returns a hash containing the data about the given expression
def lex expression
  case expression
  when /°(?<comment>.*)/
    {
      type: :comment,
      comment: $~[:comment]
    }
  when /for\s+let\s+(?<initialization>.*)\,(?<condition>.*)\,(?<update>.*)\s+do/
    {
      type: :for_loop,
      initialization: $~[:initialization],
      condition: $~[:condition],
      update: $~[:update]
    }
  when /(?<type>(boolean|int|uint|string|char))\s+(?<var_name>.*)\s=\s(?<value>.*)\Z/
    {
      type: :variable_creation,
      var_type: $~[:type],
      name: $~[:var_name],
      value: $~[:value]
    }
  when /if\s+(?<condition>.*)\s+then/ # note that this will also capture the shorthand checks so we need to compile those too
    {
      type: :if_condition,
      condition: $~[:condition]
    }
  when /alternatively\s(?<condition>.*)\s+then/
    {
      type: :alternative_condition,
      condition: $~[:condition]
    }
  when /otherwise/
    {
      type: :otherwise_condition
    }
  when /end/
    {
      type: :end
    }
  when /infer\s+(?<name>.*)\s+=\s+(?<value>.*)/
    {
      type: :inferred_variable_creation,
      name: $~[:name],
      value: $~[:value]
    }
  when /(?<function_name>.*)\((?<arguments_list>.*?)\)/ # this will capture any word and then parens: xyz(?)
    {
      type: :function_call,
      function_name: $~[:function_name],
      arguments: $~[:arguments_list]
    }
  when /fn\s+(?<function_name>.*)\((?<arguments_list>.*?)\)\s+=>\s+(?<return_type>(boolean|int|uint|string|char))\:/
    {
      type: :function_declaration,
      function_name: $~[:function_name],
      arguments: $~[:arguments_list],
      return_type: $~[:return_type]
    }
  when /while\s+(?<condition>.*)\s+do/
    {
      type: :while_loop,
      condition: $~[:condition]
    }
  when /for\s+(?<iterator>.*)\s+in\s+(?<array>.*)\s+do/
    {
      type: :foreach_loop,
      iterator: $~[:iterator],
      array: $~[:array]
    }
  when /import\s+(?<package>.*)/
    {
      type: :import,
      package: $~[:package]
    }
  when /from\s+(?<package>.*)\s+import\s+(?<thing>.*)/
    {
      type: :import_as,
      package: $~[:package],
      thing: $~[:thing]
    }
  when /(?<variable>.*)\.(?<method>.*)\((?<arguments>.*)\)$/
    {
      type: :method,
      variable: $~[:variable],
      method: $~[:method],
      arguments: $~[:arguments]
    }
  when /attempt:/
    {
      type: :open_attempt_block
    }
  when /when\s+(?<exception_type>.*)$/
    {
      type: :unnamed_when_arm,
      exception: $~[:exception_type]
    }
  when /when\s+(?<exception_type>)\s+(?<name>.*)$/
    {
      type: :named_when_arm,
      exception: $~[:exception_type],
      name: $~[:name]
    }
  else
    {
      type: :blank_line
    }
  end
end

# debug

# expressions = getExpressions("write_output('hi'); write_output('hi');")
# expressions.each do |expression|
#   puts expression
# end
