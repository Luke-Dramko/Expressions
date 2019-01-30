//
//  Sum.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 11/30/18.
//  Copyright © 2018 Luke Dramko. All rights reserved.
//

import Foundation

public class Sum: Number {
    internal let terms: [Number];
    
    public override var hashValue: Int {
        var hash = self.coefficient;
        for term in terms {
            //Overflow operator used as overflow doesn't particularly matter, and number operands are
            hash = hash &+ term.hashValue  //expected to be large.
        }
        return hash;
    }
    
    public override var description: String {
        var str = "";
        for i in 0..<(terms.count - 1) {
            if terms[i + 1].coefficient * self.coefficient < 0 {
                str += terms[i].multiple(coefficient: self.coefficient * terms[i].coefficient).description + ""; //Makes the display a litter nicer if there's a minus sign.
            } else {
                str += terms[i].multiple(coefficient: self.coefficient * terms[i].coefficient).description + " + ";
            }
            
        }
        
        //Returns a more sightly minus sign, properly spaced, instead of being attached to the
        //last term
        if terms.count > 0 {  //if terms.count > 0, there will be at least one character in the string.
            str.append(terms[terms.count - 1].multiple(coefficient: self.coefficient * terms[terms.count - 1].coefficient).description)
            return str.replacingOccurrences(of: "-", with: " - ", options: [], range: str.index(str.startIndex, offsetBy: 1)..<str.index(str.endIndex, offsetBy: 0));
        } else {
            return "\(self.coefficient)()";
        }
        
    }
    
    public override var LaTeX: String {
        var str = "";
        for i in 0..<(terms.count - 1) {
            if terms[i + 1].coefficient * self.coefficient < 1 {
                str += terms[i].multiple(coefficient: self.coefficient * terms[i].coefficient).LaTeX
            } else {
                str += terms[i].multiple(coefficient: self.coefficient * terms[i].coefficient).LaTeX + "+"
            }
        }
        return str + terms[terms.count - 1].multiple(coefficient: self.coefficient * terms[terms.count - 1].coefficient).LaTeX;
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
     Simplifies an array of Numbers by combining like terms.
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
                //term is like writing (1 + e) as (1 + e + 0)
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
     Returns the sum in its factored form.  Only common factors to each term are factored out.
     (For example, the function returns [x, 3x + 1] for 3x^2 + x, but [x^2 + 2x + 1] for x^2 + 2x + 1).
     
     -Return: The Sum in factored form.
     */
    internal func factor() -> [Number] {
        var common = Set<Number>();
        var termContents = [Set<Number>](repeating: Set<Number>(), count: terms.count);
        var exponents = Dictionary<Number, Number>();
        var termExponents = [Dictionary<Number, Number>](repeating: Dictionary<Number, Number>(), count: terms.count)
        
        //This SHOULDN'T happen, as the module enforces that terms has zero or more elements.
        if terms.count == 0 {
            return []
        }
        
        //Effectively converts the terms array into an array of sets instead, which are easier to work with.
        for (i, t) in terms.enumerated() {
            if let p = t as? Product {
                for f in p.factors {
                    if let e = f as? Exponential, e.exponent ~ Number.one {
                        if let val = exponents[e.base] {
                            exponents[e.base] = val.coefficient < e.exponent.coefficient ? val : e.exponent;
                        } else {
                            exponents[e.base] = e.exponent
                        }
                        termExponents[i][e.base] = e.exponent
                        termContents[i].insert(e.base)
                    } else {
                        if let val = exponents[f] {
                            exponents[f] = val.coefficient < f.coefficient ? val : Number.one;
                        } else {
                            exponents[f] = Number.one
                        }
                        termExponents[i][f] = Number.one
                        termContents[i].insert(f)
                    }
                }
            } else {
                if let e = t as? Exponential, e.exponent ~ Number.one {
                    if let val = exponents[e.base] {
                        exponents[e.base] = val.coefficient < e.exponent.coefficient ? val : e.exponent;
                    } else {
                        exponents[e.base] = e.exponent
                    }
                    termExponents[i][e.base] = e.exponent
                    termContents[i].insert(e.base)
                } else {
                    if let val = exponents[t] {
                        exponents[t] = val.coefficient < t.coefficient ? val : Number.one;
                    } else {
                        exponents[t] = Number.one
                    }
                    termExponents[i][t] = Number.one
                    termContents[i].insert(t)
                }
            }
        }
        
        //Find the common factors between all terms
        common = termContents[0]
        for i in 1..<termContents.count {
            common = common.intersection(termContents[i])
            
        }
        
        //Nothing can be factored out.
        if common.count == 0 {
            return [self]
        }
        
        var result = [Number]()
        
        //This set of if statements determines the Number that's been factored out.
        if common.count == 1 {
            //The two force-unwrappings are okay here.  All elements in common are keys in exponents, and
            //common will have one element to be returned by .first
            let exp = exponents[common.first!]!
            if exp == Number.one {
                result.append(common.first!.multiple(coefficient: self.coefficient))
            } else {
                result.append(Exponential(coefficient: self.coefficient, base: common.first!, exponent: exp))
            }
        } else {
            var factoredTerm = [Number]();
            for factor in common {
                let exp = exponents[factor]!
                if exp == Number.one {
                    factoredTerm.append(factor)
                } else {
                    factoredTerm.append(Exponential(base: factor, exponent: exp))
                }
            }
            result.append(Product(coefficient: self.coefficient, factoredTerm))
        }
        
        //forming a new sum with the common factors factored out
        var newTerms = [Number]();
        for (i, term) in termContents.enumerated() {
            var nt: Number = Number(terms[i].coefficient)
            for factor in term {
                if let commonExponent = exponents[factor], common.contains(factor) {
                    //Factoring a terms out involves subtracting exponents.
                    let newExponent = termExponents[i][factor]! - commonExponent
                    if newExponent == Number.one {
                        nt = nt * factor
                    } else if newExponent != Number.zero {
                        nt = nt * Exponential(base: factor, exponent: newExponent)
                    }
                } else {
                    let oldExponent = termExponents[i][factor]!
                    if oldExponent == Number.one {
                        nt = nt * factor
                    } else {
                        nt = nt * Exponential(base: factor, exponent: oldExponent)
                        
                        //Note that the numbers' exponent before the factoring could not have been zero.
                    }
                }
            } //End to inside for loop
            
            newTerms.append(nt)
        }
        
        //The factored out portion has already been appended.  Now, the remenants of the sum are being appended
        //as well.
        result.append(Sum(newTerms))
        
        return result
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
        if nt.count == 0 {
            return Number(0)
        } else if nt.count == 1 {
            return nt[0] //If there's only one item in the sum, then we might as well return just that
                         //item, not the item in a Sum 'wrapper'
        } else {
            return Sum(nt)
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
