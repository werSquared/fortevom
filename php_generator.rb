
def phpGenerateComment(comment)
  <<-COMMENT
    # #{comment}
  COMMENT
end

def phpGenerateVariable(_type, name, value)
  # type isn't used, but it's necessary in the C# version, and the parser doesn't know which one is going to be called
  <<-VAR
  $#{name} = #{value};
  VAR
end

def phpGenerateIf(condition)
  <<-IF
  if (#{condition}) {
  IF
end

def phpGenerateElseIf(condition)
  <<-ELSEIF
  } elseif (#{condition}) {
  ELSEIF
end

def phpGenerateElse
  <<-ELSE
} else {
  ELSE
end

def phpGenerateEnd
  <<-END
}
  END
end

def phpGenerateInferredVariable(name, value)
  <<-INFER
  $#{name} = #{value};
  INFER
end

def phpGenerateFunctionCall(name, arguments)
  # check if it's a fortevom function like write_output() or read_stdin()
  return "echo #{arguments}" if name == 'write_output'
  return 'readline()' if name == 'read_stdin'

  <<-CALL
  #{name}(#{arguments})
  CALL
end

def phpGenerateFunctionDeclaration(name, arguments)
  <<-DECLARATION
  function #{name} (#{arguments})
  DECLARATION
end

def phpGenerateWhileLoop(condition)
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

# TODO: I believe this is wrong
# I'm pretty sure PHP has real for loops.
def phpGenerateForLoop(initialization, condition, update)
  <<-FOR
  $#{initialization};
  while ($#{condition}) {
  $#{update}
  FOR
end

def phpGenerateForeachLoop(iterator, array)
  <<-FOREACH
  foreach ($#{array} as $#{iterator}) {
  FOREACH
end

def phpGenerateImport(_package)
  "// PHP doesn't have imports! — Fortevom" # doesn't exist in PHP
end

def phpGenerateImportFrom(_package, _thing)
  "// PHP doesn't have imports! — Fortevom" # doesn't exist in PHP either
end

def transpileMethodIntoPhp(method)
  return case method
         when 'length'   then 'count'
         when 'pushTAIL' then 'array_push'
         when 'pushHEAD' then 'array_unshift'
         when 'find'     then 'array_search'
         when 'head'     then 'array_last'
         when 'tail'     then 'array_first'
         else method # assume that the method is some other PHP method instead of throwing an error
         end
end

def phpGenerateMethod(variable, method, arguments)
  # array[i] will not reach this function, so I need to figure that out.
  method = transpileMethodIntoPhp method
  if ['', ' '].include? arguments # this check may not work; it's checking if this method is called with arguments
    "#{method}(#{variable})"
  else
    "#{method}(#{variable}, #{arguments})"
  end
end

def phpGenerateAttempt
  <<-ATTEMPT
  try {
  ATTEMPT
end

def phpGenerateCatchException(exception)
  <<-CATCH
} catch (#{exception}) {
  CATCH
end

def phpGenerateNamedException(exception, name)
  <<-CATCH
} catch (#{exception} #{name}) {
  CATCH
end
