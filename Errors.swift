//
//  Errors.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 12/15/18.
//  Copyright © 2018 Luke Dramko. All rights reserved.
//

import Foundation

//For approximation() function in Number and subclasses
enum ApproximationError: Error {
    case UndefinedConstantError(String)
}

//For the parser
enum ParseError: Error {
    case EmptyExpression
}
