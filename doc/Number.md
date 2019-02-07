Object

# Number
Number represents a mathematical number or expression exactly and symbolically.

Implements:<br>
_CustomStringConvertible_, _Comparable_, _Hashable_

Number and its subclasses are immutable objects representing a symbolic number or expression, such as x, 4y, or (3a + 7)/2.  Subclasses of Number can be used to represent increasingly complex expressions, but these classes do not have outwardly-facing intializers; only the Number class itself does.  Instead, complicated structures can be created in two ways:

1. Using the `simplify(String) throws -> Number` function:
```
var x = try! Expressions.simplify("(3a + 7)/2 + (2a + 3)/4")
```

2. By building up numbers from more basic Numbers:
```
var x = Number("x") + Number("y") + Number(4)
```

All Number subclasses are polymorphic in all public properties and methods, and can be treated as if they were instances of Number.  The programmer need not concern themselves with which subclass of Number a given variable is.

Number objects are more than just ways to store an expression.  They can be combined through operators, and are simplified
automatically as appropriate.

Number objects are maintained in a consistent interal format governed by the following rules:
 - Expressions are kept fully expanded
 - Expressions are combined into a single fraction, when appropriate
 - Expressions composed of a collection of numbers (such as factors in a product or terms in a sum) are kept in a specific sorted order.  Lower powers of exponents are "less than" higher powers of exponents and are stored first.
 - Fractions are as reduced as possible.
 - a^(-b) is stored as 1/(a^b).
 - Exponents and denominators of 1 are ignored.

Numbers can be displayed in several ways.  The `.description` property provides a human-readable representation of the Number, and the `.LaTeX` property provides a LaTeX-renderable String.  A String representing the fully factored form can be obtained with `Expressions.factored(Number, mode: DisplayMode = .description) -> String`, and a Double approximation of the Number can be obtained with the `approximate() throws -> Number` method.

Because Number objects are immutable, a given Number object always has the same value. Thus, they can be reused.  Some very common numbers are 1, 0, and -1.  The Number class provides three static Number properties that represent these:<br>
&nbsp;&nbsp;&nbsp;&nbsp;`public static let Number.one = Number(1)`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`public static let Number.zero = Number(0)`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`public static let Number.negative_one = Number(-1)`<br>
Using these over Number(1), Number(0) and Number(-1) saves repetative initialization time and storing redundant objects in memory.

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
&nbsp;&nbsp;&nbsp;&nbsp;Because 1 is such a common use case, this property is provided to reduce memory footprint and initialization time.

`let zero`<br>
&nbsp;&nbsp;&nbsp;&nbsp;A static property holding the value `Number(0)`.

`let negative_one`<br>
&nbsp;&nbsp;&nbsp;&nbsp;A static property holding the value `Number(-1)`.

## Methods
`approximate() throws -> Double`<br>
&nbsp;&nbsp;&nbsp;&nbsp;Returns an approximation of the Number, or throws an error if a symbolic constant with unknown value is found.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Approximate values for e, pi, \pi, and unicode scalar 928 (pi) are already included.<br>
&nbsp;&nbsp;&nbsp;&nbsp;Set an approximation with `Expressions.setApproximation(of: String, to: Double)`<br>
