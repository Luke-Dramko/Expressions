//
//  Token.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 1/11/19.
//  Copyright © 2019 Luke Dramko. All rights reserved.
//

import Foundation

//Represents a token from a string representing a mathematical expression.
internal enum Token {
    case addition  //matches +
    case division  //matches /
    case subtraction  //matches -
    case multiplication  //matches *
    case power //matches ^
    case symbol(String) //matches an symbolic constant: a, e, \pi, \lambda, etc.
    case integer(Int) //Matches an integer.  4, -2, 7, etc.
    case lparen
    case rparen
    case error(remainder: String) //matches an invalid piece of input.
    case empty //describes an empty string.
}
