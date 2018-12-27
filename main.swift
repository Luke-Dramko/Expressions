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
let d = Sum([N("x"), N(2)]);
let e = Sum(N("x"), N(3));
let f = d * e;
print("d = \(d)")
print("e = \(e)")
print("f = \(f)")
print("f - 5x = \(f - Sum(Number(5, "x"), Fraction(4, N(1), N(5))))")
