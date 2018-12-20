//
//  Fraction.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 11/26/18.
//  Copyright © 2018 Luke Dramko. All rights reserved.
//

import Foundation

public class Fraction: Number {
    internal let numerator: Number;
    internal let denominator: Number;
    public override var description: String {
        if numerator.description == "1" {
            return String(coefficient) + "/" + denominator.description
        } else {
            return String(coefficient) + "(" + numerator.description + ")/" + denominator.description;
        }
    };
    
    //Returns a string interpretable with LaTeX typesetting engines.
    public override var LaTeX: String {
        if numerator.description == "1" {
            return "\\frac{\(String(self.coefficient))}{\(denominator.LaTeX)}"
        } else {
            if self.coefficient == 1 {
                return "\\frac{\(numerator.LaTeX)}{\(denominator.LaTeX)}"
            } else {
                return "\\frac{\(String(self.coefficient) + "*" + numerator.LaTeX)}{\(denominator.LaTeX)}"
            }
        }
    }
    
    internal init(_ numerator: Number, _ denominator: Number) {
        self.numerator = numerator;
        self.denominator = denominator;
        super.init(); //coefficient defaults to 1.
    }
    
    internal init(_ coefficient: Int, _ numerator: Number, _ denominator: Number) {
        self.numerator = numerator
        self.denominator = denominator
        super.init(coefficient);
    }
    
    //**************** Instance methods ***************
    internal override func multiple(coefficient c: Int) -> Number {
        return Fraction(c, self.numerator, self.denominator);
    }
    
    public override func approximate() throws -> Double {
        return try (Double(self.coefficient) * numerator.approximate()) / denominator.approximate()
    }
    
    //**************** Operator Methods ***************
    
    /**
     Fraction + Fraction
     
     Adds two fractions together, no matter the type instance of the numerator and denominator.
     
     -Parameter right: The right member of the addition
     -Return: The result of the addition
     */
    internal func add(_ right: Fraction) -> Number {
        let left = self;
        
        var denominator = left.denominator;
        var numerator: Number;
        if left.denominator != right.denominator {
            /*
             a    b     ad + bc
             -- + -- = --------
             c    d       cd
             */
            denominator = left.denominator * right.denominator;
            
            /**
             a = left.numerator (though its coefficient is self.coefficient)
             b = right.numerator (though its coefficient is right.coefficient)
             c = left.denominator
             d = right.denominator
             
             numerator = (a*d).multiple(left.coefficient, d.coefficient) + (b*c).multiple(right.coefficient, c.coefficient)
            */
            numerator = (left.numerator * right.denominator).multiple(coefficient: left.coefficient * right.denominator.coefficient) + (left.denominator * right.numerator).multiple(coefficient: right.coefficient * left.denominator.coefficient)
            print("First multiplication: \(left.numerator * right.denominator)")
            print("Second multiplication: \(right.numerator * left.denominator)")
            print("Numerator = \(numerator)");
            print("Denominator = \(denominator)")
        } else {
            numerator = left.numerator + right.numerator;
        }
        
        //TODO: When the Product and Exponential classes are implemented, put a simplification
        //step here.
        
        let g: Int = gcd(numerator.coefficient, denominator.coefficient);
        
        let numeratorCoeff = numerator.coefficient / g;
        denominator = denominator.multiple(coefficient: denominator.coefficient / g)
        
        //TODO Make recalculating the numerator so many times unecessary.
        if numeratorCoeff == 0 {
            return Number(0)
        } else if denominator == Number(1) {
            return numerator.multiple(coefficient: numeratorCoeff);
        } else {
            return Fraction(numeratorCoeff, numerator.multiple(coefficient: 1), denominator)
        }
    }
    
    /**
    Fraction + Number
     
    This function handles the override of Number's multiply and determines the correct downcasted type of
    the right term if necessary.  Symbolically, this function creates a fraction over one if the right
    side is not a fraction.
     
     -Parameter right: the right term in the sum
     -Retern: The result of the sum.
    */
    internal override func add(_ right: Number) -> Number {
        switch right {
        case is Fraction:
            return self.add(right as! Fraction)
        default:
            return self.add(Fraction(right.coefficient, right.multiple(coefficient: 1), Number(1)))
        }
    }
    
    /**
    Fraction - Number
    */
    internal override func subtract(_ right: Number) -> Number {
        switch right {
        case is Fraction:
            return self.add((right as! Fraction).multiple(coefficient: -right.coefficient))
        default:
            return self.add(Fraction(-right.coefficient, right.multiple(coefficient: 1), Number(1)))
        }
    }
    
    /**
     Fraction * Fraction
     */
    internal func multiply(_ right: Fraction) -> Number {
        let numerator = self.numerator * right.numerator;
        let denominator = self.denominator * right.denominator;
        
        let g = gcd(self.coefficient * right.coefficient,  denominator.coefficient)
        print(g)
        print(numerator.coefficient / g)
        
        //TODO: Reduce common non coefficient factors.
        
        if (denominator ~ Number(1)) && (denominator.coefficient / g) == 1 {
            return numerator;
        } else {
            return Fraction((self.coefficient * right.coefficient) / g, numerator.multiple(coefficient: 1), denominator.multiple(coefficient: denominator.coefficient / g))
        }
    }
    
    /**
     Fraction * Number
     
     This helper function overrides the 
     */
    internal override func multiply(_ right: Number) -> Number {
        switch right {
        case is Fraction: return self.multiply(right as! Fraction)
        default: return self.multiply(Fraction(right.coefficient, right.multiple(coefficient: 1), Number(1)))
        }
    }
    
    /**
     Fraction / Number
     
     Divides two fractions by multiplying by the reciprocal.
     As division is routed through the multiplication function,  and does the appropriate typecasting,
     so no other overloaded division functions are necessary.
     
     -Parameter right: The number on the right of the division (i.e. self / right).
     -Returns: the result of the division.
     */
    internal override func divide(_ right: Number) -> Number {
        //Division is equivalent to multiplication by the inverse/reciprocal
        switch right {
        case is Fraction:
            let r = (right as! Fraction);
            let c = r.denominator.coefficient;
            /*
             Fractions in this module are represented as
               1x
             c----
               dy
             
             where c and d are integer coefficients and x and y are instances of Number.
             The goal is to get
             
               1y
             d----
               cx
             
             which is the reciprocal of the fraction.
             */
            return self.multiply(Fraction(c, r.denominator.multiple(coefficient: 1), r.numerator.multiple(coefficient: r.coefficient)))
        default:
            return self.multiply(Fraction(Number(1), right));
        }
    }
    
}
