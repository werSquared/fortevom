require_relative 'csharp_generator'
require_relative 'php_generator'
require_relative 'lexer'

class Parser
  def initialize
    @recognized_types = %w[uint int boolean float string char obj any]
  end

  # TODO: this will need to be refactored to support nesting

  def parse(token, output_language, line_number)
    # puts "DEBUG:"
    # pp token
    # puts token[:type]

    case token[:type]
    when :comment then send("#{output_language}GenerateComment", token[:comment])

    when :variable_creation
      unless @recognized_types.include?(token[:var_type])
        abort "Invalid type assigned to #{token[:name]}: #{token[:var_type]} on line ~#{line_number}"
      end

      send("#{output_language}GenerateVariable", token[:var_type], token[:name], token[:value])

    when :if_condition          then send("#{output_language}GenerateIf", token[:condition])
    when :alternative_condition then send("#{output_language}GenerateElseIf", token[:condition])
    when :otherwise_condition   then send("#{output_language}GenerateElse")
    when :end                   then send("#{output_language}GenerateEnd")

    when :inferred_variable_creation then send("#{output_language}GenerateInferredVariable", token[:name], token[:value])

    when :function_call        then send("#{output_language}GenerateFunctionCall", token[:function_name], token[:arguments])
    when :function_declaration then send("#{output_language}GenerateFunctionDeclaration", token [:function_name], token[:arguments], token[:return_type])
    when :while_loop           then send("#{output_language}GenerateWhileLoop", token[:condition])
    when :for_loop             then send("#{output_language}GenerateForLoop", token[:initialization], token[:condition], token[:update])
    when :foreach_loop         then send("#{output_language}GenerateForeachLoop", token[:iterator], token[:array])
    when :import               then send("#{output_language}GenerateImport", token[:package])
    when :import_as            then send("#{output_language}GenerateImportFrom", token[:package], token[:thing])
    when :method               then send("#{output_language}GenerateMethod", token[:variable], token[:method], token[:arguments])
    when :open_attempt_block   then send("#{output_language}GenerateAttempt")
    when :unnamed_when_arm     then send("#{output_language}GenerateCatchException", token[:exception])
    when :named_when_arm       then send("#{output_language}GenerateNamedException", token[:exception], token[:name])
    when :blank_line           then "\n"
    else
      abort "Unrecognized token on line #{line_number}: #{token}"
    end
  end
end