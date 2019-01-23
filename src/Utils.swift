//
//  Utils.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 12/1/18.
//  Copyright © 2018 Luke Dramko. All rights reserved.
//

import Foundation

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
