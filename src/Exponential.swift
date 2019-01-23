//
//  Exponential.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 11/30/18.
//  Copyright © 2018 Luke Dramko. All rights reserved.
//

import Foundation

public class Exponential: Number {
    internal let base: Number;
    internal let exponent: Number;
    
    public override var hashValue: Int { return coefficient &* (base.hashValue ^ exponent.hashValue) }
    
    public override var description: String {
        if coefficient == 1 {
            if base.coefficient != 0 || base is Sum {
                return "(\(base.description))^(\(exponent.description))"
            } else {
                return base.description + "^(" + exponent.description + ")";
            }
        } else if coefficient == -1 {
            return "-(\(base.description))^(\(exponent.description))"
        } else {
            return "\(self.coefficient)(\(base.description))^(\(exponent.description))"
        }
    }
        
    public override var LaTeX: String {
        let coeff: String;
        if self.coefficient == 1 {
            coeff = ""
        } else if coefficient == -1 {
            coeff = "-"
        } else {
            coeff = String(self.coefficient)
        }
        
        if self.exponent == Fraction(Number.one, Number(2)) {
            return "\(coeff)\\sqrt{\(base.LaTeX)}"
        } else {
            return "\(coeff)\(base is Sum || base.coefficient != 1 ? "(\(base.LaTeX))" : base.LaTeX)^{\(exponent.LaTeX)}"
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
    
    //**************** Instance methods *******************
    
    internal override func multiple(coefficient c: Int) -> Number {
        if self.base == Number(c) {
            return Exponential(coefficient: 1, base: self.base, exponent: self.exponent + Number.one)
        }
        return Exponential(coefficient: c, base: self.base, exponent: self.exponent);
    }
    
    
    public override func approximate() throws -> Double {
        return try Double(coefficient) * pow(base.approximate(), exponent.approximate())
    }
    
    //****************** Operator Methods *********************
    
    /**
    Exponential + Number
     
     Adds an exponential to a Number.  Unless 'right' is an Exponential both the base and exponent are equal,
     this function just returns a Sum.
     */
    public override func add(_ right: Number) -> Number {
        if let r = right as? Exponential {
            //x^5 and x^5 can be combined into 2x^5, but x^5 and x^3 really can't be.
            if self.base == r.base && self.exponent == r.exponent {
                return self.coefficient + r.coefficient == 0 ? Number.zero : self.multiple(coefficient: self.coefficient + r.coefficient)
            }
        }
        
        //All other cases must be represented by a Sum.
        return Sum(self, right)
    }
    
    //Subtract function unnecessary.
    
    /**
     Exponential * Number
     
     Multiplies an Exponential and a Number.  Combines them into a single exponential when possible; this
     can happen only when the bases are the same.  For example,
     x^4 * x^2 == x^6, and x^y * x = x^(y + 1)
     However,
     x^4 * y^4 can't be symplified any further, and a Product is returned instead.
     
     -Parameter right: The right term in multiplication
     -Return: The result of the multiplication
     */
    public override func multiply(_ right: Number) -> Number {
        //This will force the fraction's multiply and thus Fraction.reduce() function to be called to handle additional simplification.
        if right is Fraction {
            return right * self;
        }
        
        if let r = right as? Exponential {
            
            //bases are equal, can combine exponents
            if self.base == r.base {
                return Exponential(coefficient: self.coefficient * r.coefficient, base: self.base, exponent: self.exponent + r.exponent)
            }
            
            //bases are not equal; must return a Product
            return Product(coefficient: self.coefficient * r.coefficient, [self.multiple(coefficient: 1), r.multiple(coefficient: 1)])
        } else if self.base == right {
            return Exponential(coefficient: self.coefficient, base: self.base, exponent: self.exponent + Number.one)
        } else if (self.base ~ right) && self.base.coefficient == 1 {
            return Exponential(coefficient: self.coefficient * right.coefficient, base: self.base, exponent: self.exponent + Number.one)
        }
        
        //Bases are not the same.
        if right ~ Number.one {
            return self.multiple(coefficient: self.coefficient * right.coefficient)
        } else {
            return Product(coefficient: self.coefficient * right.coefficient, [self.multiple(coefficient: 1), right.multiple(coefficient: 1)])
        }
    }

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
    
    /**
     Compares two esponentials and determines if they're like terms (their base and exponent are equal).
     
     -Parameter right: the Exponential that this is being compared to
     -Return: true if the Exponentials are like terms.
     */
    public override func like(_ right: Number) -> Bool {
        if self.coefficient == 0 && right.coefficient == 0 {
            return true;
        }
        
        if let r = right as? Exponential {
            return self.base == r.base && self.exponent == r.exponent;
        } else {
            return false;
        }
    }
}
