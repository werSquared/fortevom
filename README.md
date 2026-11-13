# Fortevom

Fortevom is a pretty little language that compiles into C# and PHP.

It's designed to be a glue language for your C# or PHP projects so you can save the verbosity of C# for the parts that actually need it.

The syntax is inspired by Ruby and JavaScript, and is pretty easy to comprehend if you come from either of those.

Naturally, because Fortevom transpiles into C#/PHP, types are required, but this is to avoid any errors or problems if we were to infer the types.

# Syntax

All expressions must end with a semicolon.

## Variable declarations:

`<type> variable = value;`

Example:

`i32 weight = 46;`

The types will be mentioned later.

You can alternatively declare a variable using type inferrence:

`infer number = 96;`

## Comments

Comments are initiated with the ° (degree) symbol. On macOS, you can get this by pressing option-shift-8.

Unicode: `U+00B0`

`° This is a comment `

## Writing to STDOUT:

`write_output("hi");`

This, naturally, will return a string.

## Reading from STDIN:

`read_stdin();`

## Conditionals:

Conditional blocks must be closed with ends

```
if condition then 
  ° ...
alternatively condition then
  ° ...
otherwise do 
   ° ...
end
```

Alternatively is the equivalent of elsif, elseif, or elif;
Otherwise is the equivalent of else.

### Alternative Conditionals

You can also use the alternate inline conditional. This has the exact same syntax as Ruby:

`if <condition> then <result> end`

There are also shorthands for evaluating multiple variables against a value:

`either var1 var 2 == value` 

This is a shortcut for `if var1 == value or var2 == value`

Quick note: Fortevom uses `or` like Python does; it is the equivalent of `||` in most other languages -- 
same with `and`; it is the equivalent of `&&`


`if var1 and var2 == value then ...` 

This is the equivalent of `if var1 == value and var2 == value`


`if var1 == value and var2 doesnt then ...`

This is the equivalent of `if var1 == value and var2 =/= value`

Fortevom uses `=/=` instead of `!=` to represent the "not equals" symbol.


## Functions:

Functions are declared using the `fn` keyword:

You must declare a return type for all functions.

```
fn functionNAME() => returntype:
  <logic>
end
```

Fortevom uses toggleCASE by convention; Each word alternates between no caps and all caps.

If your function takes arguments, those arguments need a type:

```
fn someFUNCTION(string argument, bool argumentTWO) => string:
  <logic>
end
```

If you want any type of argument, then you can use the type `any`:

```
fn someFUNCTION(any argument, any argumentTWO) => string:
  <logic>
end
```

## Types

Here is the list of types available in Fortevom:
- uint
- int
- boolean
- float
- string
- char
- obj
- any/inferred

Note: if you create a variable with the `inferred` type, this just compiles into `var` in C#  — Fortevom doesn't handle the type inferrence.

When transpiling into PHP, the types are basically cosmetic, as PHP doesn't use types (in most cases).

## Loops:

```
while condition do
  ° stuff
end
```
```
for let int i = 0, condition, i++ do
  ° stuff
end
```

```
for thing in things do 
  ° stuff
end 
```

## Imports:

`import <thing>`

## Array methods:

`array.length;` => returns the amount of items in an array

`array.find(x)` => returns index of x

`array.pushTAIL(item);` => explains itself

`array.pushHEAD(item);` => pushes an item at the very first index

`array.indexPUSH(item, i);` => pushes item at index i 

`array[i]` => access index i

`array.head` => first index

`array.tail` => last index

You can also use any C# or PHP method, which will be passed through untouched.

## Error handling:

```
attempt {
  ° error-prone code
}
when EXCEPTIONcode {
  ° what to do if it breaks
}
```

The exception will be passed through untouched into C# or PHP — Fortevom has no custom exceptions.

# Credits

The syntax of Fortevom was heavily inspired by [Wernasho](https://github.com/werSquared), and the leading force for the development of Fortevom was for his project, [Kyogas](https://github.com/pixelqualitysoftware/kyogas).

The internals of Fortevom, as well as this readme, were created by [Reece Turner](https://github.com/Centurion774477).

The README was purified using [Murman](https://github.com/Centurion774477/Murman).

# Where's the install section?

Fortevom isn't quite ready for use yet, but I'm actively working on getting it ready.

# Yakima

Also see [Yakima](https://github.com/Centurion774477/Yakima), which is a fork of Fortevom meant to be more expressive and a bit more laid back.
