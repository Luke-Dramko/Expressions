//
//  Sum.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 11/30/18.
//  Copyright © 2018 Luke Dramko. All rights reserved.
//

import Foundation

public class Sum: Number {
    private let terms: [Number];
    public override var description: String {
        var str = "";
        for i in 0..<(terms.count - 1) {
            if terms[i + 1].coefficient < 0 {
                str += terms[i].multiple(coefficient: self.coefficient * terms[i].coefficient).description + ""; //Makes the display a litter nicer if there's a minus sign.
            } else {
                str += terms[i].multiple(coefficient: self.coefficient * terms[i].coefficient).description + " + ";
            }
            
        }
        
        //Returns a more sightly minus sign, properly spaced, instead of being attached to the
        //last term
        if terms.count > 0 {  //if terms.count > 0, there will be at least one character in the string.
            str.append(terms[terms.count - 1].multiple(coefficient: self.coefficient * terms[terms.count - 1].coefficient).description)
            return "(" + str.replacingOccurrences(of: "-", with: " - ", options: [], range: str.index(str.startIndex, offsetBy: 1)..<str.index(str.endIndex, offsetBy: 0)) + ")";
        } else {
            return "\(self.coefficient)()";
        }
        
    }
    
    public override var LaTeX: String {
        var str = "\(self.coefficient)(";
        for i in 0..<(terms.count - 1) {
            if terms[i + 1].coefficient < 0 {
                str += terms[i].LaTeX + ""; //Makes the display a litter nicer if there's a minus sign.
            } else {
                str += terms[i].LaTeX + " + ";
            }
        }
        return str + terms[terms.count - 1].LaTeX + ")";
    }
    
    internal convenience init(_ n1: Number, _ n2: Number) {
        self.init([n1, n2]);
    }
    
    internal convenience init(_ inTerms: [Number]) {
        self.init(1, inTerms);
    }
    
    internal required init(_ c: Int, _ inTerms: [Number]) {
        var g: Int = inTerms[0].coefficient;
        for i in 1..<inTerms.count {
            g = gcd(inTerms[i].coefficient, g)
        }
        
        var newterms: [Number] = [];
        for term in inTerms {
            newterms.append(term.multiple(coefficient: term.coefficient / g))
        }
        
        //sorting ensures that two sums can be compared term-wise for equality, and also ensures
        //consistent display.
        terms = newterms.sorted();
        super.init(c * g)
    }
    
    //********************* Miscellaneous Helpers ***********************
    
    /**
     Simplifys an array of Numbers by combining like terms.
     Precondition: The array is sorted, so like terms are next to eachother.
     
     "Like Terms" are defined using the 'like' operator, ~
     
     -Parameter nt: "new terms" the array of terms to be simplified.
     */
    private static func simplify(_ nt: inout [Number]) {
        //Based on the sorting order, like terms are always next to eachother.
        var i: Int = 0;
        while (i < nt.count) {
            //Combine like terms
            //We want to make sure terms are like before adding them so we don't end up nesting
            //Sum objects.
            if ((i + 1 < nt.count) && (nt[i] ~ nt[i + 1])) {
                nt[i] = nt[i] + nt[i + 1]
                nt.remove(at: i + 1) //Remove the extra copy after combining terms
                
                //If two numbers cancel out, we remove the zero from the sum - keeping an extra zero
                //term is like righting (1 + e) as (1 + e + 0)
                if nt[i] == Number(0) {
                    nt.remove(at: i)
                }
            } else {
                //If the current term and the next term aren't like terms, then we look at the next one.
                i+=1;
            }
        }
    }
    
    //************** Instance methods *************
    internal override func multiple(coefficient c: Int) -> Number {
        return Sum(c, self.terms);
    }
    
    public override func approximate() throws -> Double {
        var total: Double = 0.0;
        
        for term in terms {
            //Each term has to be multiplied by coefficient, because coefficient is represented as
            //coefficient(term + term + ... + term)
            try total += term.approximate() * Double(self.coefficient);
        }
        
        return total;
    }
    
    /**
     Returns the sum in its factored form.  A sum in this module is represented by
     
     c(ax + by), where c is the coefficient, an integer.
     
     This function returns the Sum itself factored, including the terms inside of it.
     The Sum
     3(4ax + x) would be factored as 3x(4a + 1), and returned as a tuple of (3x, (4a + 1)).
     
     */
    public func factored() -> (Number, Sum) {
        if terms.count == 0 {
            return (Number.one, Sum([Number.one]));
        }
        
        var commonFactors: Array<Number>;
        
        if let p = terms[0] as? Product {
            commonFactors = p.factors;
        } else {
            commonFactors = [terms[0].multiple(coefficient: 1)]
        }
        
        for i in 1..<terms.count {
            if let p = terms[i] as? Product { //(Number) throws -> Bool
                commonFactors = commonFactors.filter({ num in !p.factors.contains(where: { $0 ~ num }) })
            } else {
                commonFactors = commonFactors.filter( { $0 ~ terms[i]} )
            }
        }
        
        if commonFactors.count == 0 {
            return (Number.one, self)
        } else if commonFactors.count == 1 {
            return (commonFactors[0], self)
        } else {
            return (Product(coefficient: 1, commonFactors), self)
        }
    }
    
    /**
     Private helper function to assist in distributing the factored coefficient to each term.  This
     form is more useful for individual calculations.  Essentailly does a(x + y + ...) -> ax + ay + ...,
     where a is a constant and x and y are instances of Number.
     
     -Return a term array after the distribution process.
     */
    private func distribute() -> [Number] {
        var nt = [Number]();
        for term in self.terms {
            nt.append(term.multiple(coefficient: self.coefficient * term.coefficient))
        }
        return nt;
    }
    
    //*************** Operator Methods **************
    
    /**
     Sum + Number
     
     Prepares an operation for the Sum + Sum function.
     
     -Parameter right: The right term in the sum
     -Return: The result of the operations.
     */
    internal override func add(_ right: Number) -> Number {
        //TODO Make fraction sum case consistent accross package.  Currently, fractions are
        //only combined through the Fraction + Number (and thus through the Fraction + Fraction) function.
        switch right {
        case is Sum: return self.add(right as! Sum)
        default: return self.add(Sum([right]))
        }
    }
    
    /**
     Sum + Sum
     
     Adds two sets of terms to eachother.
     */
    internal func add(_ right: Sum) -> Number {
        var nt = self.distribute() + right.distribute(); //New terms
        nt.sort();
        
        Sum.simplify(&nt)
        
        //Handle special cases or return the new sum.
        if terms.count == 0 {
            return Number(0)
        } else if terms.count == 1 {
            return nt[0] //If there's only one item in the sum, then we might as well return just that
                         //item, not the item in a Sum 'wrapper'
        } else {
            return Sum(nt)
        }
    }
    
    /**
     Sum - Number
     
     Subtracts two numbers.  In this module, subtraction is defined as addition with a negative coefficient.
     
     -Parameter right: The Number to subtract from this Sum.
     -Return: The result of the operation.
     */
    internal override func subtract(_ right: Number) -> Number {
        switch right {
        case is Sum: return self.add(right.multiple(coefficient: -right.coefficient) as! Sum)
        default: return self.add(Sum([right.multiple(coefficient: -right.coefficient)]))
        }
    }
    
    /**
     Sum * Number
     Sum * Sum
     
     Returns the result of multiplying two Sums together.  The process is defined recursively.
     
     -Parameter right: The Number this Sum is being multiplied by
     -Return: The result of the operation.
     */
    internal override func multiply(_ right: Number) -> Number {
        if let r = right as? Sum {
            var result = Number(0);
            
            //This is essentially the FOIL process taught in algebra.
            for term in r.distribute() {
                result = result + (self * term)
            }
            return result;
        }
        
        var nt: [Number] = []; //This is distributing the coefficient.
        for term in self.distribute() {
            nt.append(right * term)
        }
        
        //Terms must be sorted before simplification.
        nt.sort()
        
        Sum.simplify(&nt);
        
        //Handle special cases or return the new sum.
        if terms.count == 0 {
            return Number(0)
        } else if terms.count == 1 {
            return nt[0] //If there's only one item in the sum, then we might as well return just that
            //item, not the item in a Sum 'wrapper'
        } else {
            return Sum(nt)
        }
    }
    
    /**
     Divides a Sum by another number.
     
     This function actually sets up a Fraction for multiplication.  The call is routed through
     Fraction.multiply(), which actually does the work.
     
     -Parameter right: The denominator in the division
     -Return: The result of the division operation
     */
    internal override func divide(_ right: Number) -> Number {
        //Because the call is intended to be routed through Fraction.multiply anyway, we want the
        //Fraction to be first to potentially avoid an extra call.  It's best practice to always
        //use the symbolic operators (+, -, *, etc.) instead of the instance methods.
        print("In Sum.divide, self = \(self)")
        return Fraction(1, Number(1), right) * self
    }
    
    /**
     Compares two Sums, and returns true if all of their terms are equal, and false otherwise.
     
     Sums are kept sorted, so comparison in order is acceptable.
     
     -Parameter right: the Sum to compare this Sum to
     -Return: true if all terms and the coefficients are equal and false otherwise.
     */
    internal override func equals(_ right: Number) -> Bool {
        if self.coefficient == 0 && right.coefficient == 0 {
            return true;
        }
        
        if self.coefficient != right.coefficient {
            return false;
        }
        
        if let r = right as? Sum {
            for i in 0..<terms.count {
                if !(self.terms[i] == r.terms[i]) {
                    return false
                }
                return true;
            }
        }
        return false;
    }
    
    /**
     Compares two Sums, and returns true if they're the same within a coefficient of eachother.
     
     Sums are kept sorted, so comparison in order is acceptable.
     
     -Parameter right: Sum to compare this Sum to
     -Return: true if all terms are equivalent and false otherwise.
     */
    internal override func like(_ right: Number) -> Bool {
        if self.coefficient == 0 && right.coefficient == 0 {
            return true;
        }
        
        if let r = right as? Sum {
            return self.terms == r.terms;
        } else {
            return false;
        }
    }
}
