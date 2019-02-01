//
//  Utils.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 12/1/18.
//  Copyright © 2018 Luke Dramko. All rights reserved.
//

import Foundation


public enum DisplayMode {
    case description
    case LaTeX
}

/**
 Returns a string representing the factored form of the argument.  Numbers, including products of sums, are
 kept fully expanded.  However, sometimes it is desirable to view a sum in its factored form.  This function
 provides an easy way to see this, without violating the expected internal format for Numbers.
 
 -Parameter n: The number to display
 -Parameter mode: The type of description to return - the numbers' description or LaTeX property value
 -Return: A description of the Number.
 */
public func factored(_ n: Number, mode: DisplayMode = .description) -> String {
    if let s = n as? Sum {
        let p = Product(coefficient: 1, s.factor())
        switch mode {
        case .description: return p.description
        case .LaTeX: return p.LaTeX
        }
    }
    
    switch mode {
    case .description: return n.description
    case .LaTeX: return n.LaTeX
    }
}

/**
 Allows the framework user to set approximations for certain variable values.
 
 -Parameter set: string values to set an approximation for
 -Parameter to: value the value of the approximation
 -Parameter overridingValues: if there is already an approximation for the given string, set a new one anyway?
 */
public func setApproximation(set key: String, to value: Double, overridingValues override: Bool = false) {
    if Number.approximations[key] == nil || override {
        Number.approximations[key] = value;
    }
}

//the gcd and lcm functions are public as they may be useful outside the package as well.

public func gcd(_ num1: Int, _ num2: Int) -> Int {
    if (num1 > num2) {
        return gcd_helper(larger: num1, smaller: num2)
    } else {
        return gcd_helper(larger: num2, smaller: num1)
    }
}

//Greatest common divisor.  Useful for adding and simplifiying fractions.
fileprivate func gcd_helper(larger: Int, smaller: Int) -> Int {
    if (smaller == 0) {
        return larger;
    }
    return gcd_helper(larger: smaller, smaller: (larger % smaller));
}

//Least common multiple.  Useful for adding and simplifying fractions.
public func lcm(_ a: Int, _ b: Int) -> Int {
    return a * b / gcd(a, b)
}
