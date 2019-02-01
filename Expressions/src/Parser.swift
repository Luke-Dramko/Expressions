//
//  Parser.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 1/15/19.
//  Copyright © 2019 Luke Dramko. All rights reserved.
//

import Foundation

public func simplify(_ exp: String) throws -> Number {
    var tokenizer = try ExpressionTokenizer(exp)
    let result = try expression(&tokenizer)
    if tokenizer.peek() == nil {
        return result;
    } else if let err = tokenizer.peek(), case .error(let message) = err {
        throw ParseError.InvalidToken(message)
    } else {
        throw ParseError.ExpressionEndExpected
    }
}

/*
 Grammar used for this parser:
 
 expression: term + expression | term - expression | term
 term: -term | +term | product / factor | product / factor * term | product
 product: factor * product | factor product | factor
 factor: element ^ factor | element
 element: ( expression ) | integer | symbol
 
 Note that for expression - term, the negative sign is NOT popped out of the token queue.  This is
 to preserve order of operations.  As written, term - expression indicates term + -1( expression ),
 where the intended behavior is -1 times the next term only.  The difference comes when 'expression'
 is more than one term, as in a - a + b.  The first technique will result in -b, which is incorrect;
 we want b instead.
 */


//expression: term + expression | term - expression | term
fileprivate func expression(_ t: inout ExpressionTokenizer) throws -> Number {
    let x = try term(&t)
    if addition(&t) {
        return try x + expression(&t) //term + expression
    }
    
    if let token = t.peek(), case .subtraction = token {
        return try x + expression(&t) //term - expression
    }
    
    return x; //term
}

//term: -term | +term | product / factor | product / factor * term | product
fileprivate func term(_ t: inout ExpressionTokenizer) throws -> Number {
    if subtraction(&t) { //-term
        return try Number.negative_one * term(&t)
    }
    
    if addition(&t) { //+term
        return try term(&t)
    }
    
    var x = try product(&t)
    
    if division(&t) {
        x = try x / factor(&t)
        if multiplication(&t) {
            return try x * term(&t) //product / factor * term
        } else {
            return x; //product / factor
        }
    }
    
    return x; //product
}

//product: factor * product | factor product | factor
fileprivate func product(_ t: inout ExpressionTokenizer) throws -> Number {
    let x = try factor(&t)
    
    if multiplication(&t) { //factor * product
        return try x * product(&t)
    }
    
    if elementIsNext(t) {
        return try x * product(&t) //factor product
    }
    
    return x //factor
}

//factor: element ^ factor | element
fileprivate func factor(_ t: inout ExpressionTokenizer) throws -> Number {
    let x = try element(&t)
    
    if power(&t) {  //element ^ factor
        return try x ^ factor(&t)
    }
    
    return x;  //element
}

//element: ( expression ) | integer | symbol
fileprivate func element(_ t: inout ExpressionTokenizer) throws -> Number {
    if lparen(&t) { // ( expression )
        let x = try expression(&t)
        if rparen(&t) {
            return x
        } else {
            throw ParseError.ExpectedToken(")")
        }
    }
    
    if let n = integer(&t) { //integer
        return n;
    } else if let s = symbol(&t) { //symbol
        return s
    } else {
        throw ParseError.ExpectedToken("Integer or Symbol")
    }
}


//*********** Token identifying functions ***************

/**
 The token identification functions below all follow a similar pattern.  They interact directly with the
 tokenizer.  If the next token is the same as the name of the function, the function returns the appropriate
 Number or true; otherwise, the function returns nil or false.  This abstracts away the necessity of handling
 the tokenizer on this level in the recursive descent parser functions above.
 */
fileprivate func symbol(_ t: inout ExpressionTokenizer) -> Number? {
    if let token = t.peek(), case .symbol(let constant) = token {
        let _ = t.pop(); //Unused call is fine here; the result of peek and pop are the same, and so we don't need
                 //to do anything else with it.
        return Number(constant);
    } else {
        return nil;
    }
}

fileprivate func integer(_ t: inout ExpressionTokenizer) -> Number? {
    if let token = t.peek(), case .integer(let constant) = token {
        let _ = t.pop()
        return Number(constant)
    } else {
        return nil
    }
}

fileprivate func addition(_ t: inout ExpressionTokenizer) -> Bool {
    if let token = t.peek(), case .addition = token {
        let _ = t.pop()
        return true;
    } else {
        return false;
    }
}

fileprivate func subtraction(_ t: inout ExpressionTokenizer) -> Bool {
    if let token = t.peek(), case .subtraction = token {
        let _ = t.pop()
        return true;
    } else {
        return false;
    }
}

fileprivate func multiplication(_ t: inout ExpressionTokenizer) -> Bool {
    if let token = t.peek(), case .multiplication = token {
        let _ = t.pop()
        return true;
    } else {
        return false;
    }
}

fileprivate func division(_ t: inout ExpressionTokenizer) -> Bool {
    if let token = t.peek(), case .division = token {
        let _ = t.pop()
        return true;
    } else {
        return false;
    }
}

fileprivate func power(_ t: inout ExpressionTokenizer) -> Bool {
    if let token = t.peek(), case .power = token {
        let _ = t.pop()
        return true;
    } else {
        return false;
    }
}

fileprivate func lparen(_ t: inout ExpressionTokenizer) -> Bool {
    if let token = t.peek(), case .lparen = token {
        let _ = t.pop()
        return true;
    } else {
        return false;
    }
}

fileprivate func rparen(_ t: inout ExpressionTokenizer) -> Bool {
    if let token = t.peek(), case .rparen = token {
        let _ = t.pop()
        return true;
    } else {
        return false;
    }
}

//********************* Other Helper Functions ***********************
fileprivate func elementIsNext(_ t: ExpressionTokenizer) -> Bool {
    if let token = t.peek() {
        switch token {
        case .integer, .symbol, .lparen: return true;
        default: return false;
        }
    } else {
        return false
    }
}
