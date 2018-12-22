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
    
    //**************** Instance methods
    
    internal override func multiple(coefficient c: Int) -> Number {
        return Exponential(coefficient: c, base: self.base, exponent: self.exponent);
    }
    
    
    public override func approximate() throws -> Double {
        return try Double(coefficient) * pow(base.approximate(), exponent.approximate())
    }
    
    //****************** Operator Methods *********************
    /**
     Compares two exponentials, and determines if they're equal (their base, coefficient, and exponent
     are all equal).
     
     -Parameter right: the Exponential to compare this Exponential to
     -Return: true if the exponentials are equal and false otherwise.
     */
    public override func equals(_ right: Number) -> Bool {
        if self.coefficient == 0 && right.coefficient == 0 {
            return true;
        }
        
        if let r = right as? Exponential {
            return self.coefficient == r.coefficient && self.base == r.base && self.exponent == r.exponent;
        }
        return false;
    }
}
