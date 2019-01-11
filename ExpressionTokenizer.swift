//
//  ExpressionTokenizer.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 1/10/19.
//  Copyright © 2019 Luke Dramko. All rights reserved.
//


import Foundation

struct ExpressionTokenizer: Sequence {
    var expression: String
    
    init(_ e: String) {
        self.expression = e;
    }
    
    internal func makeIterator() -> ExpressionTokenizer.Iterator {
        <#code#>
    }
    
    /**
     Iterator returns the next token, or none if there's nothing left in the string to parse.
     */
    struct Iterator: IteratorProtocol {
        
        mutating func next() -> Token? {
            
        }
    }
}
