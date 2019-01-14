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
    var current: Token = .empty //placeholder value
    
    //Regular expressions
    let add_sign = try! NSRegularExpression(pattern: "^\\+")
    let minus_sign = try! NSRegularExpression(pattern: "^-")
    let multiplication_sign = try! NSRegularExpression(pattern: "^\\*")
    let division_sign = try! NSRegularExpression(pattern: "^/")
    let exponentiation_sign = try! NSRegularExpression(pattern: "^^")
    let symbol = try! NSRegularExpression(pattern: "^[a-zA-Z]|\\\\[a-zA-Z]+")
    let integer = try! NSRegularExpression(pattern: "^[0-9]+")
    let whitespace = try! NSRegularExpression(pattern: "^\\s*")
    let lparen = try! NSRegularExpression(pattern: "^\\(")
    let rparen = try! NSRegularExpression(pattern: "^\\)")
    
    init(_ e: String) throws {
        if e.count == 0 { //empty string doesn't make sense as an expression.
            throw ParseError.EmptyExpression
        }
        self.expression = e;
        self.current = next();
    }
    
    private mutating func next() -> Token {
        if let _ = add_sign.firstMatch(in: expression) {
            expression.remove(at: expression.startIndex)
            return .addition
        } else if let _ = minus_sign.firstMatch(in: expression) {
            expression.remove(at: expression.startIndex)
            return .subtraction
        } else if let _ = division_sign.firstMatch(in: expression) {
            expression.remove(at: expression.startIndex)
            return .division
        } else if let _ = multiplication_sign.firstMatch(in: expression) {
            expression.remove(at: expression.startIndex)
            return .multiplication
        } else if let _ = exponentiation_sign.firstMatch(in: expression) {
            expression.remove(at: expression.startIndex)
            return .power
        } else if let s = symbol.firstMatch(in: expression) {
            expression.remove(at: expression.startIndex)
            return .symbol(s)
        } else if let i = integer.firstMatch(in: expression) {
            return .integer(Int(i)!) //force-unwrap is okay because regular expression ensures it's an int.
        } else if let _ = whitespace.firstMatch(in: expression) {
            return self.next()
        } else if let _ = lparen.firstMatch(in: expression) {
            expression.remove(at: expression.startIndex)
            return .lparen
        } else if let _ = rparen.firstMatch(in: expression) {
            expression.remove(at: expression.startIndex)
            return .rparen
        } else if expression == "" {
            return .empty
        }
        
        return .error(remainder: expression)
    }
    
    internal func peek() -> Token {
        return .empty //temporary placeholder
    }
    
    internal func pop() -> Token {
        return .empty //temporary placeholder
    }  
    
}

extension NSRegularExpression {
    public func firstMatch(in str: String) -> String? {
        //self.firstMatch(in: str, options: range: NSRange(str.startIndex..., in: str)))
        let match = self.firstMatch(in: str, range: NSRange(str.startIndex..., in: str))
        
        return match.map {
            String(str[Range($0.range, in: str)!])
        }
        
        
    }
}
