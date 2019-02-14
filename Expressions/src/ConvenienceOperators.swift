//
//  ConvenienceOperators.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 1/23/19.
//  Copyright © 2019 Luke Dramko. All rights reserved.
//

import Foundation

/*
 This file contains overloaded operator menthods meant to make working with Number classes easier. They
 package native Swift types in the appropriate Number object, then delegate to a left: Number, right: Number
 operator.
 */

infix operator **

public func + (left: Int, right: Number) -> Number {
    return Number(left) + right
}

public func + (left: Number, right: Int) -> Number {
    return left + Number(right)
}

public func - (left: Int, right: Number) -> Number {
    return Number(left) + right.multiple(coefficient: -right.coefficient)
}

public func - (left: Number, right: Int) -> Number {
    return left + Number(-right)
}

public func * (left: Int, right: Number) -> Number {
    return Number(left) * right
}

public func * (left: Number, right: Int) -> Number {
    return left * Number(right)
}

public func / (left: Int, right: Number) -> Number {
    return Number(left) / right
}

public func / (left: Number, right: Int) -> Number {
    return left / Number(right)
}

public func ^ (left: Int, right: Number) -> Number {
    return Number(left) ^ right
}

public func ^ (left: Number, right: Int) -> Number {
    return left ^ Number(right)
}

//The ** operator aliases to ^
public func ** (left: Number, right: Number) -> Number {
    return left ^ right;
}

public func ** (left: Number, right: Int) -> Number {
    return left ^ Number(right)
}

public func ** (left: Int, right: Number) -> Number {
    return Number(left) ^ right
}

public func == (left: Number, right: Int) -> Bool {
    return left == Number(right)
}

public func == (left: Int, right: Number) -> Bool {
    return Number(left) == right
}
