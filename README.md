# Numbers
Numbers is a package of swift objects which performs mathematical operations symbolically.

Numbers objects can represent fractions and complex expressions in terms of multiple variables.  

Number objects can be created in several ways:

`let num1 = Number(4) * Number("x") + Number(2)  //num1 is 4x + 2 `

`let num2 = Number(3, "y")  //num2 is 3y`

`let num3 = try! simplify("(3x + 2)(x + 5)")  //num3 is 3x^2 + 17x + 10`

Numbers can be combined via overloaded operators to create different Numbers.  Numbers are always kept in simplified form.

```
var expr = try! simplify("(x + 4)^(3/2)/(x + 4)^(1/2)")  //expr is x + 4

expr = expr - Number(4)  //expr is now x.
```

Number objects can be converted to a LaTeX String for easy rendering.

```
var expr = try! simplify("(x/2 + y^(1/2))^2")

print(expr.LaTeX)   //prints \frac{4y+4x\sqrt{y}+x^{2}}{4}
```
This renders to

<a href="https://www.codecogs.com/eqnedit.php?latex=\frac{4y&plus;4x\sqrt{y}&plus;x^{2}}{4}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\frac{4y&plus;4x\sqrt{y}&plus;x^{2}}{4}" title="\frac{4y+4x\sqrt{y}+x^{2}}{4}" /></a>
