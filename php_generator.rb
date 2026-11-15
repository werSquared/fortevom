
def php_generate_comment(comment)
  <<-COMMENT
    # #{comment}
  COMMENT
end

def php_generate_variable(_type, name, value)
  # type isn't used, but it's necessary in the C# version, and the parser doesn't know which one is going to be called
  <<-VAR
  $#{name} = #{value};
  VAR
end

def php_generate_if(condition)
  <<-IF
  if (#{condition}) {
  IF
end

def php_generate_elseif(condition)
  <<-ELSEIF
  } elseif (#{condition}) {
  ELSEIF
end

def php_generate_else
  <<-ELSE
} else {
  ELSE
end

def php_generate_end
  <<-END
}
  END
end

def php_generate_inferred_variable(name, value)
  <<-INFER
  $#{name} = #{value};
  INFER
end

def php_generate_function_call(name, arguments)
  # check if it's a fortevom function like write_output() or read_stdin()
  return "echo #{arguments}" if name == 'write_output'
  return 'readline()' if name == 'read_stdin'

  <<-CALL
  #{name}(#{arguments})
  CALL
end

def php_generate_function_declaration(name, arguments)
  <<-DECLARATION
  function #{name} (#{arguments})
  DECLARATION
end

def php_generate_while_loop(condition)
  # if the user is checking for a boolean value or a variable
  if condition =~ /^\w+$/
    return <<-WHILE
    while ($#{condition}) {
    WHILE
  end

  <<-WHILE
  while (#{condition}) {
  WHILE
end

# TODO: I believe this is wrong —
# I'm pretty sure PHP has real for loops.
def php_generate_for_loop(initialization, condition, update)
  <<-FOR
  $#{initialization};
  while ($#{condition}) {
  $#{update}
  FOR
end

def php_generate_foreach_loop(iterator, array)
  <<-FOREACH
  foreach ($#{array} as $#{iterator}) {
  FOREACH
end

def php_generate_import(_package)
  # TODO: throw an error instead of just writing a comment
  "// PHP doesn't have imports! — Fortevom" # doesn't exist in PHP
end

def php_generate_import_from(_package, _thing)
  # TODO: throw an error instead of just writing a comment
  "// PHP doesn't have imports! — Fortevom" # doesn't exist in PHP either
end

def transpile_method_into_php(method)
  case method
  when 'length'   then 'count'
  when 'pushTAIL' then 'array_push'
  when 'pushHEAD' then 'array_unshift'
  when 'find'     then 'array_search'
  when 'head'     then 'array_last'
  when 'tail'     then 'array_first'
  else method # assume that the method is some other PHP method instead of throwing an error
  end
end

def php_generate_method(variable, method, arguments)
  # array[i] will not reach this function, so I need to figure that out.
  method = transpile_method_into_php method
  if ['', ' '].include? arguments # this check may not work; it's checking if this method is called with arguments
    "#{method}(#{variable})"
  else
    "#{method}(#{variable}, #{arguments})"
  end
end

def php_generate_attempt
  <<-ATTEMPT
  try {
  ATTEMPT
end

def php_generate_catch_exception(exception)
  <<-CATCH
} catch (#{exception}) {
  CATCH
end

def php_generate_named_exception(exception, name)
  <<-CATCH
} catch (#{exception} #{name}) {
  CATCH
end
