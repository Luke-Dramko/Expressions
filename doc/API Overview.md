# API
The following functions are avaliable for creating and manuiplating symbolic numbers and expressions.

## Creating Numbers
**Using the Simplify Function**<br />
`simplify(_:String) throws -> Number`<br />
&nbsp;&nbsp;&nbsp;&nbsp;Parses a string representing a mathematical expression and returns the apropriate Number.

**Using Number() Initializers**<br>
`init(_:Int)`<br />
&nbsp;&nbsp;&nbsp;&nbsp;Creates a basic integer Number with the given value.

`init(_:String)`<br />
&nbsp;&nbsp;&nbsp;&nbsp;Creates a basic symbolic Number of the type String, with a coefficient of 1.

`init(_:Int, _:String)`<br />
&nbsp;&nbsp;&nbsp;&nbsp;Creates a basic symbolic Number with a given coefficient and symbol, such as 4x.

## Combining and Manipulating Numbers
Number objects can be combined through several operators that mimic the normal mathematical operators +, -, *, /, and ^ (for raising to a power).  Using these operators can automatically create polymorphic subclass representations of Numbers when more complicated structures are necessary.

For convenience, these operators are overloaded to accept a single integer argument along with a Number; if `x` is an instance of Number, instead of `x ^ Number(2)`, it's only necessary to use `x ^ 2`.

Examples
```Swift
var expr = try! simplify("abc - bca") //expr = 0

expr = try! expr + simplify("(x + 1)^2")  //expr = x^2 + 2x + 1

expr = expr - Number(2, "x") - 1 //expr = x^2 + 1
```

Numbers can be compared with the == operator, which returns true if the left and right are symbolically identical and false otherwise.

Numbers can also be compared with the ~ ("like") infix operator, which returns true if the left and right are like terms.  Like terms differ only in coefficient. 
```Swift
Number(4, "x") ~ Number(4, "x) // returns true

try! simplify("x ^ 3") ~ simplify("5x ^ 3") //returns true

Number(4, "x") ~ Number(4) //returns false
```

## Displaying and Aproximating Numbers
Number objects can be converted back into native data types in three ways: as a description string, as a renderable LaTeX string, and as a Double aproximation, when possible.

Number (and its subclasses) implement `CustomStringConvertible`, and thus has a `description` property which describes the Number.  It's automatically called when used in string interpolation.

Number (and its subclasses) have a LaTeX property, which returns a string ready-made to work with a LaTeX rendering engine.

The approximate() method returns an approximation of the Number, if possible.  Some values, like 'pi' and 'e', have known approximations, while others, like 'a' or 'lambda', do not.  If a symbol with an unknown approximation is encountered, an UndefinedConstantError is thrown.
