//
//  main.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 11/26/18.
//  Copyright © 2018 Luke Dramko. All rights reserved.
//
//  This program is for informal testing only.  It is not intended to be part of the final product.
//

import Foundation
typealias N = Number

//print("Division: \(Number(10) / Number(5, "a"))")
//print("Addition: \(Number(10) + Number(5, "a"))")
//print("Multiplication: \(Number(10) * Number(5, "a"))")
//print("Subtraction: \(Number(10) - Number(5, "a"))");

/**
print();
print("Fraction addition: ")
let v1: Fraction = N(4) / N(5) as! Fraction;
let v2: Fraction = N(5) / N(6) as! Fraction;
print("Result = \(v1 + v2)")
print()
print("Really adding fractions: \(Fraction(6, Number(1), Number(7)) + Fraction(2, Number(1), Number(3)))")
*/
/*
let x = Fraction(4, N(1), N(5, "e")) * Fraction(2, N(1), N(5))
print(x)
print(try? x.approximate())
print(x.LaTeX)

var y = Fraction(2, N(1), N(5))
var z = x / y
print("z = \(z)")
print("z's LaTeX = \(z.LaTeX)")

z = z / Number(2);
print("z = \(z)")
print("z's LaTeX = \(z.LaTeX)")
*/
/*
let a = Sum([Number(4, "e"), Number(2), Number(-4, "a")])
let b = Sum(Number(-3, "e"), Number(4, "a"))
let c = a + b
print(a)
print(b)
print(c.description)
print(c.LaTeX)

print(Exponential(coefficient: 3, base: Product(coefficient: 4, N("a"), N("b")), exponent: Fraction(N(1), N(2))).LaTeX) */

/*
let d = Sum([N("x"), N(2)]);
let e = Sum(N("x"), N(3));
let f = d * e;
let g = Sum(N(4, "x"), N(5))
print("d = \(d)")
print("e = \(e)")
print("f = \(f)")
//print("f = \(f / Sum(Number(5, "x"), Fraction(4, N(1), N(5))))")
print(g / Number(8, "x"))
print("-----------------------------") */
/*
let h = (Number(3) * Number("x")) * Number("a")
print("h = \(h)")
let i = Product(coefficient: 4, Number("x"), Number("a"))
print(h + i)
print((h + i).LaTeX)
*/
/*
let j = Number(15) * Number("x")
let k = Number("x") * Number(4, "y")
let l = Product(coefficient: 7, [Number("y"), Number("z"), Exponential(base: Number("x"), exponent: Fraction(1, Number.one, Number(2)))])
print("l = \(l)")
let jk = j * k;
print("jk = \(jk)")
print("k = \(k)")
print("jk / k = \((jk / k).LaTeX)") */
/*
let m = Exponential(base: Number(3), exponent: Number("x"))
let n = Exponential(coefficient: 2, base: Number(3), exponent: Number("x"))
let o = Number(3)
print((m * n) * o) */
/*
var x = Number(4) * Number("x") * Number("y") * Number("y") * Exponential(coefficient: 3, base: Number("z"), exponent: Number("a"))
var y = Number(5) * Exponential(coefficient: 6, base: Number("z"), exponent: Number(4)) * Exponential(base: Number("x"), exponent: Number(-2))
print((x / y).LaTeX)

print("------------------------")
x = Number(2, "x") + Fraction(6, Number(1, "y"), Number(4, "z"))
print(x)
y = Number(2, "a")
print((x / y).LaTeX) */
/*
let one = Number.one;
let two = Number(2)
let x = Number("x")
let y = Number("y")
let z = Number("z")
let xyz = Product(coefficient: 1, [x, y, z])
let two_over_x = Fraction(2, Number.one, x)

let product = Fraction(3, xyz, two)

var array: [Number] = [Exponential(base: Number("x"), exponent: Number(2)), Number("x"), Number("x") * Number(3), Exponential(base: Number("x"), exponent: Number(3)), Exponential(base: Number("x"), exponent: Number("y")), Number("x"), Exponential(base: Number("y"), exponent: Number(2)), Exponential(base: Number("y"), exponent: Number("x")), Exponential(base: Number("x"), exponent: Number(2))]
var additions: [Number] = [Product(coefficient: 4, [x, y, z]), Product(coefficient: 2, [z, y, x]), x, Product(coefficient: 2, [z, x]), Product(coefficient: 3, [x, y]), Product(coefficient: 7, [y, z]), Product(coefficient: 5, [x, z])]

array = array + additions

additions = [Fraction(1, two, x), Fraction(1, x, two), Fraction(1, x, two), Fraction(3, Product(coefficient: 1, [x, y, z]), two)]

array = array + additions

print("array[5] is Product = \(array[5] is Product)")
print("x < 3x = \(Number("x") < Number(3, "x"))")
print("before sorting, array = \(array)")
array.sort()
print("after sorting, array = \(array)") */

//var tokenizer = try! ExpressionTokenizer("a + b * c^d^f/4 (a + b)^(b - a) \\pi\\pi a\\lambda 4 4000 20 -9 500")
//while let t = tokenizer.pop() {
//    print(t)
//}
//print(Sum(Number("x"), Number.one) ^ Number(-2))

let x = try! simplify("12a^2bc + 16a^4b + 8a^3bd^y")
print(x)
print(factored(x, mode: .LaTeX))
print(try! simplify("(a + b)^(c + d)").LaTeX)
exit(0)

print("Enter expressions:")
var input: String = readLine(strippingNewline: true)!
while input != "" {
    do {
        let x = try simplify(input)
        print(x)
        print(x.LaTeX)
    } catch {
        print("Parse error: \(error)")
    }
    print("--------------")
    input = readLine(strippingNewline: true)!
}

