# Design Philosophy
The Expressions package is designed to allow for symbolic computation in an easy and intuitive way.  Numbers can be treated similarly to native Swift types in many ways.

The core of the Expressions package is the Number object. Number objects are immutable, like Strings in many languages, including Java and Python. This protects agains unintended side effects due to aliasing.
The Number class has several subclasses: Sum, Product, Fraction, and Exponential. These represent relationships between Numbers in an expression.

Complicated expressions are defined recursively. Such an expression is effectively a tree, with all terminal nodes non-subclass instances of Number. Internally, 7 + 2xy + 3x^(2a) would be represented as:<br>
<img src="https://github.com/Luke-Dramko/Expressions/blob/master/doc/images/ExpressionTree.png" height="377" width="698">

Note that each type of Number is associated with a coefficient, which simplifies internal calculations. The coefficient property is not visible outside the package.
Internally, Number objects and their subclasses follow a set of organizational rules that simplify calculations by reducing redundant states: expressions that are logically equal but represented differently symbolically. This set of rules is summarized as follows:
* Expressions are kept fully expanded
* Expressions are combined into a single fraction, when appropriate
* Expressions composed of a collection of numbers (such as factors in a product or terms in a sum) are kept in a specific sorted order. Lower powers of exponents are "less than" higher powers of exponents and are stored first.
* Fractions are as reduced as possible.
* a^(-b) is stored as 1/(a^b).
* Exponents and denominators of 1 are ignored.

If Numbers are operated on through the public API, these properties are maintained automatically.

Due to the rules above, constructors for subclasses of Number are not a part of the API to prevent the creation of mathematically correct but programmatically invalid combinations of Numbers, such as (x + 1)^1 or 4/1, etc. Instead, these structures are built up as necessary through the use of operators of though the `Expressions.simplify(String)` function.
