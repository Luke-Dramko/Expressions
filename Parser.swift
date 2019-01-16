//
//  Parser.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 1/15/19.
//  Copyright © 2019 Luke Dramko. All rights reserved.
//

import Foundation

public func simplify(_ exp: String) throws -> Number {
    let tokenizer = try ExpressionTokenizer(exp)
    
    return Number.one //placeholder
}


//*********** Token identifying functions ***************
fileprivate func symbol(_ tokenizer: ExpressionTokenizer) -> Number? {
    var t = tokenizer;
    if let token = t.peek(), case .symbol(let constant) = token {
        t.pop(); //Unused call is fine here, the result of peek and pop are the same, and so we don't need
                 //to do anything else with it.
        return Number(constant);
    } else {
        return nil;
    }
}

fileprivate func integer(_ tokenizer: ExpressionTokenizer) -> Number? {
    var t = tokenizer;
    if let token = t.peek(), case .integer(let constant) = token {
        t.pop()
        return Number(constant)
    } else {
        return nil
    }
}

fileprivate func addition(_ tokenizer: ExpressionTokenizer) -> Bool {
    var t = tokenizer;
    if let token = t.peek(), case .addition = token {
        t.pop()
        return true;
    } else {
        return false;
    }
}

fileprivate func subtraction(_ tokenizer: ExpressionTokenizer) -> Bool {
    var t = tokenizer;
    if let token = t.peek(), case .subtraction = token {
        t.pop()
        return true;
    } else {
        return false;
    }
}

fileprivate func multiplication(_ tokenizer: ExpressionTokenizer) -> Bool {
    var t = tokenizer;
    if let token = t.peek(), case .multiplication = token {
        t.pop()
        return true;
    } else {
        return false;
    }
}

fileprivate func division(_ tokenizer: ExpressionTokenizer) -> Bool {
    var t = tokenizer;
    if let token = t.peek(), case .division = token {
        t.pop()
        return true;
    } else {
        return false;
    }
}

fileprivate func power(_ tokenizer: ExpressionTokenizer) -> Bool {
    var t = tokenizer;
    if let token = t.peek(), case .power = token {
        t.pop()
        return true;
    } else {
        return false;
    }
}

fileprivate func lparen(_ tokenizer: ExpressionTokenizer) -> Bool {
    var t = tokenizer;
    if let token = t.peek(), case .lparen = token {
        t.pop()
        return true;
    } else {
        return false;
    }
}
