# Operators

`Number + Number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Adds two Numbers together

`Number - Number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Subtracts one Number from another

`Number * Number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Multiplies two Numbers together.

`Number / Number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Divides one Number by another

`Number ^ Number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Raises the first Number to the power of the second.
&nbsp;&nbsp;&nbsp;&nbsp;In order to use ^, you must put `infix operator ^` at the file scope.

`Number ** Number`<br>
&nbsp;&nbsp;&nbsp;&nbsp;An alias for ^, this function raises the first Number to the power of the second.

Each of these is available with and Int as either argument, such as `Number + Int` and `Int * Number`.  Thus, it’s possible to do 
```
var x = Number(“a”);

x = x + 1  // x is now a + 1
```
These are simply ‘convenience operators’, much like convenience initializers in Swift classes.  They package the Int into a Number, and call the corresponding Number [operator] Number function.
