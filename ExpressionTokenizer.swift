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
    
    init(_ e: String) throws {
        if e.count == 0 { //empty string can't be parsed and doesn't make sense as an expression.
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
