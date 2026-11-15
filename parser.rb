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
    when :comment then send("#{output_language}_generate_comment", token[:comment])

    when :variable_creation
      unless @recognized_types.include?(token[:var_type])
        abort "Invalid type assigned to #{token[:name]}: #{token[:var_type]} on line ~#{line_number}"
      end

      send("#{output_language}_generate_variable", token[:var_type], token[:name], token[:value])

    when :if_condition          then send("#{output_language}_generate_if", token[:condition])
    when :alternative_condition then send("#{output_language}_generate_elseif", token[:condition])
    when :otherwise_condition   then send("#{output_language}_generate_else")
    when :end                   then send("#{output_language}_generate_end")

    when :inferred_variable_creation then send("#{output_language}_generate_inferred_variable", token[:name], token[:value])

    when :function_call        then send("#{output_language}_generate_function_call", token[:function_name], token[:arguments])
    when :function_declaration then send("#{output_language}_generate_function_declaration", token [:function_name], token[:arguments], token[:return_type])
    when :while_loop           then send("#{output_language}_generate_while_loop", token[:condition])
    when :for_loop             then send("#{output_language}_generate_for_loop", token[:initialization], token[:condition], token[:update])
    when :foreach_loop         then send("#{output_language}_generate_foreach_loop", token[:iterator], token[:array])
    when :import               then send("#{output_language}_generate_import", token[:package])
    when :import_as            then send("#{output_language}_generate_import_from", token[:package], token[:thing])
    when :method               then send("#{output_language}_generate_method", token[:variable], token[:method], token[:arguments])
    when :open_attempt_block   then send("#{output_language}_generate_attempt")
    when :unnamed_when_arm     then send("#{output_language}_generate_catch_exception", token[:exception])
    when :named_when_arm       then send("#{output_language}_generate_named_exception", token[:exception], token[:name])
    when :blank_line           then "\n"
    else
      abort "Unrecognized token on line #{line_number}: #{token}"
    end
  end
end