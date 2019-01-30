# Numbers
Numbers is a package of swift objects which performs mathematical operations symbolically.

Numbers objects can represent fractions and complex expressions in terms of multiple variables.  

Number objects can be created in several ways:

`let num1 = Number(4) * Number("x") + Number(2)  //num1 is 4x + 2 `

`let num2 = Number(3, "y")  //num2 is 3y`

`let num3 = try! simplify("(3x + 2)(x + 5)")  //num3 is 3x^2 + 17x + 10`

Numbers can be combined via overloaded operators to create different Numbers.  Numbers are always kept in simplified form. Operators are overloaded to accept Int parameters that automatically convert the Int to a Number instance for convenience. 

```Swift
var expr = try! simplify("(x + 4)^(3/2)/(x + 4)^(1/2)")  //expr is x + 4

expr = expr - 4  //expr is now x.
```

Number objects can be converted to a LaTeX String for easy rendering.

```Swift
var expr = try! simplify("(x/2 + y^(1/2))^2")

print(expr.LaTeX)   //prints \frac{4y+4x\sqrt{y}+x^{2}}{4}
```
This renders to

<a href="https://www.codecogs.com/eqnedit.php?latex=\frac{4y&plus;4x\sqrt{y}&plus;x^{2}}{4}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\frac{4y&plus;4x\sqrt{y}&plus;x^{2}}{4}" title="\frac{4y+4x\sqrt{y}+x^{2}}{4}" /></a>

Finally, if a symbol's numeric value is known, approximations can be calculated for a given Number.

```Swift
let x: Double = try! Number(2, "\\pi").approximate()  //x is 6.283185307179586

let y: Double? = try? Number(2, "a").approximate()  //y is nil due to an UndefinedConstantError
```
