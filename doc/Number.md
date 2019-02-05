Object

# Number
Number represents a mathematical number or expression exactly and symbolically.

Implements:<br>
CustomStringConvertible, Comparable, Hashable

## Initializers
`init(Int)`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Initializes a basic Number with a specified integer value.

`init(String)`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Initializes a basic Number with a specified symbolic value. This could be a variable, such as x, or a constant, such as e.

`init(Int, String)`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Initializes a basic Number as a simple term: a symbol and its coefficient.

## Instance Properties
`var description: String`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Called automatically when used in String interpolation, the description property creates a human-readable representation of the Number.

`var LaTeX: String`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Returns a LaTeX renderable String.

## Static Properties
`let one`<br>
&nbsp;&nbsp;&nbsp;&nbsp;A static property holding the value `Number(1)`.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Because 1 is such a common use case, this property is provided to reduce memory footprint an initialization time.

`let zero`<br>
&nbsp;&nbsp;&nbsp;&nbsp;A static property holding the value `Number(0)`.

`let negative_one`<br>
&nbsp;&nbsp;&nbsp;&nbsp;A static property holding the value `Number(-1)`.

## Methods
`approximate() throws -> Double`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Returns an approximation of the Number, or throws an error if a symbolic constant with unknown value is found.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Approximate values for e, pi, \pi, and unicode scalar 928 (pi) are already included.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Set an approximation with `Expressions.setApproximation(of: String, to: Double)`<br>
