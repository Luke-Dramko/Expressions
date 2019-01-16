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
    return try expression(tokenizer)
}

fileprivate func expression(_ t: ExpressionTokenizer) throws -> Number {
    var x = try term(t)
    if addition(t) {
        x = try x + expression(t)
    }
    
    if subtraction(t) {
        x = try x + expression(t)
    }
    
    return x;
}

fileprivate func term(_ t: ExpressionTokenizer) throws -> Number {
    
}

fileprivate func term_tail(_ t: ExpressionTokenizer) throws -> Number {
    
}

fileprivate func product(_ t: ExpressionTokenizer) throws -> Number {
    
}

fileprivate func factor(_ t: ExpressionTokenizer) throws -> Number {
    
}


//*********** Token identifying functions ***************

/**
 The token identification functions below all follow a similar pattern.  They interact directly with the
 tokenizer.  If the next token is the same as the name of the function, the function returns the appropriate
 Number or true; otherwise, the function returns nil or false.  This abstracts away the necessity of handling
 the tokenizer on this level in the recursive descent parser functions above.
 */
fileprivate func symbol(_ tokenizer: ExpressionTokenizer) -> Number? {
    var t = tokenizer;
    if let token = t.peek(), case .symbol(let constant) = token {
        t.pop(); //Unused call is fine here; the result of peek and pop are the same, and so we don't need
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

fileprivate func rparen(_ tokenizer: ExpressionTokenizer) -> Bool {
    var t = tokenizer;
    if let token = t.peek(), case .rparen = token {
        t.pop()
        return true;
    } else {
        return false;
    }
}
