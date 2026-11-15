
def cs_generate_comment(content)
  <<-COMMENT
    // #{content}
  COMMENT
end

def cs_generate_variable(type, name, value)
  <<-VARIABLE
    #{type} #{name} = #{value};
  VARIABLE
end

def cs_generate_if(condition)
  <<-IF
    if (#{condition}) {
  IF
end

def cs_generate_elseif(condition)
  <<-ELSEIF
  } else if (#{condition}) {
  ELSEIF
end

def cs_generate_else
  <<-ELSE
  } else {
  ELSE
end

def cs_generate_end
  <<-END
  }
  END
end

def cs_generate_inferred_variable(name, value)
  <<-INFER
  var #{name} = #{value};
  INFER
end

def cs_generate_function_call(name, arguments)
  return "Console.WriteLine(#{arguments});" if name == 'write_output'
  return 'Console.ReadLine();' if name == 'read_stdin'

  <<-CALL
  #{name}(#{arguments});
  CALL
end

# TODO: This should probably be more complex — just public might not be detailed enough.
def cs_generate_function_declaration(name, arguments, return_type)
  <<-DECLARATION
  public #{return_type} #{name}(#{arguments}) {
  DECLARATION
end

def cs_generate_while_loop(condition)
  <<-WHILE
  while (#{condition}) {
  WHILE
end

def cs_generate_for_loop(initialization, condition, update)
  <<-FOR
  for (#{initialization}; #{condition}; #{update}) {
  FOR
end

def cs_generate_foreach_loop(iterator, array)
  <<-FOREACH
  foreach (var #{iterator} in #{array}) {
  FOREACH
end

def cs_generate_import(package)
  <<-IMPORT
  using #{package};
  IMPORT
end

def cs_generate_import_from(package, _thing)
  # I don't think C# has an import x from y feature
  <<-IMPORT
  using #{package};
  IMPORT
end

# handle all the methods that aren't supported in the C# version
def transpile_method_into_csharp(method)
  abort 'Sorry, but when transpiling Fortevom into C#, the method pushTAIL is not supported.' if method == 'pushTAIL'

  abort 'Sorry, but when transpiling Fortevom into C#, the method pushHEAD is not supported.' if method == 'pushHEAD'

  abort 'Sorry, but when transpiling Fortevom into C#, the method pushHEAD is not supported.' if method == 'pushHEAD'

  case method
  when 'length' then 'Length'
  when 'find'   then 'Find'
  else method
  end
end

def cs_generate_method(variable, method)
  # preprocess method if it's a custom Fortevom method
  return "#{variable}[0]" if method == 'head'
  return "#{variable}[#{variable}.Length - 1]" if method == 'tail'

  transpiledMethod = transpile_method_into_csharp method

  <<-METHOD
    #{variable}.#{transpiledMethod};
  METHOD
end

def cs_generate_attempt
  <<-ATTEMPT
    try {
  ATTEMPT
end

def cs_generate_catch_exception(exception)
  # this might throw a warning (if not an error) if you pull down throwawayException but don't use it.
  # I'm not sure if C# lets you capture specific exceptions while not pulling down a variable, though.
  <<-CATCH
  } (#{exception} throwawayException) {
  CATCH
end

def cs_generate_named_exception(exception, name)
  <<-CATCH
  } (#{exception} #{name}) {
  CATCH
end

