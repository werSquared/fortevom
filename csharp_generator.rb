
def csGenerateComment(content)
  <<-COMMENT
    // #{content}
  COMMENT
end

def csGenerateVariable(type, name, value)
  <<-VARIABLE
    #{type} #{name} = #{value};
  VARIABLE
end

def csGenerateIf(condition)
  <<-IF
    if (#{condition}) {
  IF
end

def csGenerateElseIf(condition)
  <<-ELSEIF
  } else if (#{condition}) {
  ELSEIF
end

def csGenerateElse
  <<-ELSE
  } else {
  ELSE
end

def csGenerateEnd
  <<-END
  }
  END
end

def csGenerateInferredVariable(name, value)
  <<-INFER
  var #{name} = #{value};
  INFER
end

def csGenerateFunctionCall(name, arguments)
  return "Console.WriteLine(#{arguments});" if name == 'write_output'
  return 'Console.ReadLine();' if name == 'read_stdin'

  <<-CALL
  name(#{arguments});
  CALL
end

# TODO: This should probably be more complex — just public might not be detailed enough.
def csGenerateFunctionDeclaration(name, arguments, return_type)
  <<-DECLARATION
  public #{return_type} #{name}(#{arguments}) {
  DECLARATION
end

def csGenerateWhileLoop(condition)
  <<-WHILE
  while (#{condition}) {
  WHILE
end

def csGenerateForLoop(initialization, condition, update)
  <<-FOR
  for (#{initialization}; #{condition}; #{update}) {
  FOR
end

def csGenerateForeachLoop(iterator, array)
  <<-FOREACH
  foreach (var #{iterator} in #{array}) {
  FOREACH
end

def csGenerateImport(package)
  <<-IMPORT
  using #{package};
  IMPORT
end

def csGenerateImportFrom(package, _thing)
  # I don't think C# has an import x from y feature
  <<-IMPORT
  using #{package};
  IMPORT
end

# handle all the methods that aren't supported in the C# version
def transpileMethodIntoCsharp(method)
  abort 'Sorry, but when transpiling Fortevom into C#, the method pushTAIL is not supported.' if method == 'pushTAIL'

  abort 'Sorry, but when transpiling Fortevom into C#, the method pushHEAD is not supported.' if method == 'pushHEAD'

  abort 'Sorry, but when transpiling Fortevom into C#, the method pushHEAD is not supported.' if method == 'pushHEAD'

  case method
  when 'length' then 'Length'
  when 'find'   then 'Find'
  else method
  end
end

def csGenerateMethod(variable, method)
  # preprocess method if it's a custom Fortevom method
  return "#{variable}[0]" if method == 'head'
  return "#{variable}[#{variable}.Length - 1]" if method == 'tail'

  transpiledMethod = transpileMethodIntoCsharp method

  <<-METHOD
    #{variable}.#{transpiledMethod};
  METHOD
end

def csGenerateAttempt
  <<-ATTEMPT
    try {
  ATTEMPT
end

def csGenerateCatchException(exception)
  # this might throw a warning (if not an error) if you pull down throwawayException but don't use it.
  # I'm not sure if C# lets you capture specific exceptions while not pulling down a variable, though.
  <<-CATCH
  } (#{exception} throwawayException) {
  CATCH
end

def csGenerateNamedException(exception, name)
  <<-CATCH
  } (#{exception} #{name}) {
  CATCH
end

