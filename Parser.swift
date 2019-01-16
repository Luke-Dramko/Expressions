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
fileprivate func symbol(_ t: ExpressionTokenizer) -> Number? {
    if let token = t.peek(), case .symbol(let constant) = token {
        return Number(constant);
    } else {
        return nil;
    }
}
