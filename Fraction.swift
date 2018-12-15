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
    
    //**************** Operator Methods ***************
    
    /**
     Fraction + Fraction
     */
    internal override func add(_ right: Fraction) -> Number {
        print("Fraction + Fraction")
        print("-------------------")
        print("Adding \(self) + \(right)")
        
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
        
        print("Calculating gcd = \(g)")
        
        let numeratorCoeff = numerator.coefficient / g;
        denominator = denominator.multiple(coefficient: denominator.coefficient / g)
        
        //TODO Make recalculating the numerator so many times unecessary.
        if denominator == Number(1) {
            return numerator.multiple(coefficient: numeratorCoeff);
        } else {
            return Fraction(numeratorCoeff, numerator.multiple(coefficient: 1), denominator)
        }
    }
    
    internal override func add(_ right: Number) -> Number {
        print("Fraction + Number")
        switch right {
        case is Fraction:
            return self.add(right as! Fraction)
        default:
            return self.add(Fraction(right.coefficient, right.multiple(coefficient: 1), Number(1)))
        }
    }
    
}
