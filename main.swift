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
