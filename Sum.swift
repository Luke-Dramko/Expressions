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
                str += terms[i].description + ""; //Makes the display a litter nicer if there's a minus sign.
            } else {
                str += terms[i].description + " + ";
            }
            
        }
        
        //Returns a more sightly minus sign, properly spaced, instead of being attached to the
        //last term
        str.append(terms[terms.count - 1].description)
        if terms.count > 0 {  //if terms.count > 0, there will be at least one character in the string.
            return "\(self.coefficient)(" + str.replacingOccurrences(of: "-", with: " - ", options: [], range: str.index(str.startIndex, offsetBy: 1)..<str.index(str.endIndex, offsetBy: 0)) + ")";
        } else {
            return "\(self.coefficient)()";
        }
        
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
        terms = newterms;
        super.init(c * g)
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
}
