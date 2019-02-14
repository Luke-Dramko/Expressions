# Operators

The Expressions package makes available several operators to combine and manipulate Numbers.  As Numbers are immutable, operators which return a Number return a new Number, not a mutated operand.

`Number + Number -> Number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Adds two Numbers together

`Number - Number -> Number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Subtracts one Number from another

`Number * Number -> Number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Multiplies two Numbers together.

`Number / Number -> Number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Divides one Number by another

`Number ^ Number -> Number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Raises the first Number to the power of the second.<br>
&nbsp;&nbsp;&nbsp;&nbsp;In order to use ^, you must put `infix operator ^` at the file scope.

`Number ** Number -> Number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;An alias for ^, this function raises the first Number to the power of the second.

`Number == Number -> Bool`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Returns true if the Numbers are symbolically equal, and false otherwise.  Numbers are maintained such that mathematically equal Numbers are stored in the same format and thus equal by this equals method.

Each of these is available with and Int as either argument, such as `Number + Int` and `Int * Number`.  Thus, it’s possible to do:
```
var x = Number(“a”);

x = x + 1  // x is now a + 1
```
These are simply ‘convenience operators’, much like convenience initializers in Swift classes.  They package the Int into a Number, and call the corresponding Number [operator] Number function.

The Numbers framework defines two additional operators without Int convenience operators.

`Number ~ Number -> Bool`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Returns true if the two Numbers are like terms, that is, one is a constant multiple of the other.

`Number !~ Number -> Bool`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Returns the negation of the ~ operator.

The `<` operator is defined and available at the public access level in order to satisfy `Comparable`.  **However, it compares Numbers such that like terms are sorted next to eachother.**  Using it for other purposes may yield unintended behavior. It does not use the Numbers' approximate values, as the approximate() function can fail with an UndefinedConstantError.

`Number < Number -> Bool`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Compares Numbers such that like terms are sorted next to eachother.
