//
//  ExpressionTokenizer.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 1/10/19.
//  Copyright © 2019 Luke Dramko. All rights reserved.
//


import Foundation

struct ExpressionTokenizer {
    var expression: String
    var current: Token = .empty
    
    //Regular expressions
    let add_sign = try! NSRegularExpression(pattern: "^\\+")
    let minus_sign = try! NSRegularExpression(pattern: "^-")
    let multiplication_sign = try! NSRegularExpression(pattern: "^\\*")
    let division_sign = try! NSRegularExpression(pattern: "^/")
    let symbol = try! NSRegularExpression(pattern: "^[a-zA-Z]|\\\\[a-zA-Z]+")
    let integer = try! NSRegularExpression(pattern: "^[0-9]+")
    let whitespace = try! NSRegularExpression(pattern: "^\\s")
    
    init(_ e: String) throws {
        if e.count == 0 { //empty string doesn't make sense as an expression.
            throw ParseError.EmptyExpression
        }
        self.expression = e;
        self.current = next();
    }
    
    private func next() -> Token {
        return .empty //temporary placeholder
    }
    
    internal func peek() -> Token {
        return .empty //temporary placeholder
    }
    
    internal func pop() -> Token {
        return .empty //temporary placeholder
    }  
    
}
