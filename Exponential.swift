//
//  Exponential.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 11/30/18.
//  Copyright © 2018 Luke Dramko. All rights reserved.
//

import Foundation

public class Exponential: Number {
    private var base: Number;
    private var exponent: Number;
    public override var description: String { return base.description + "^(" + exponent.description + ")"; }
    public override var LaTeX: String {
        if self.coefficient == 1 {
            return "\(base.LaTeX)^{\(exponent.LaTeX)}"
        } else {
            return "\(self.coefficient)(\(base.LaTeX))^{\(exponent.LaTeX)}";
        }
    }
    
    required init(coefficient: Int, base: Number, exponent: Number) {
        self.base = base;
        self.exponent = exponent;
        super.init(coefficient);
    }
    
    convenience init(base: Number, exponent: Number) {
        self.init(coefficient: 1, base: base, exponent: exponent);
    }
    
    
    public override func approximate() throws -> Double {
        return try Double(coefficient) * pow(base.approximate(), exponent.approximate())
    }
    
    
}
