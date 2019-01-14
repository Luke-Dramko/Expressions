//
//  File.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 11/26/18.
//  Copyright © 2018 Luke Dramko. All rights reserved.
//

import Foundation

infix operator ~
infix operator !~
infix operator ^

public class Number: CustomStringConvertible, Comparable, Hashable {
    internal static var approximations: [String: Double] = ["": 1, "e": 2.71828_18284_59045_23536, "pi": Double.pi, "\\pi": Double.pi, "\u{03C0}": Double.pi]
    
    internal let coefficient: Int;
    internal let constant: String;
    
    /*
     These static variables exist so a new "1" Number doesn't have to be initialized every time the
     number 1 is needed, which is quite often.  The same goes for 0 and -1.  Numbers are immutable and
     thus the same one can be used any time Number(1), Number(0), or Number(-1) is needed.
     
     These are public so they can be called outside the module if the user wishes to reduce memory footprint.
     */
    public static let one = Number(1)
    public static let zero = Number(0)
    public static let negative_one = Number(-1)
    
    public var hashValue: Int {
        return constant.hashValue ^ coefficient.hashValue;
    }
    
    //Computed properties
    public var description: String {
        if coefficient == 0 {
            return "0";
        }
        
        if coefficient == 1 {
            if constant == "" {
                return "1";
            } else {
                return constant;
            }
        } else {
            return String(coefficient) + constant;
        }
    }
    
    //Returns a version of the string renderable by LaTeX typesetting engines.
    public var LaTeX: String {
        return self.description
    }
    
    
    //**************** Constructors ****************
    //Public initializers
    
    /**
     A simple constructor that initializes the basic number class with an integer.
 
     Parameter inVal: the input integer.
    */
    public init(_ coefficient: Int) {
        self.coefficient = coefficient;
        constant = "";
    }
    
    /**
     This constructor allows for mathematical constants in addition to integer numbers.
     
     Parameter inVal: The integer coefficient the number represents
     Parameter inCons: A string representing the constants.
     */
    public init(_ constant: String) {
        coefficient = 1;
        self.constant = constant;
    }
    
    public init(_ coefficient: Int, _ constant: String) {
        self.coefficient = coefficient;
        self.constant = constant
    }
    
    //Internal only initializer
    
    /**
     A constructor meant for internal use inside the Numbers package only.  It can initialize the
     class with nil.
     
     This is important if a subclass is delegating to this one and doesn't need to use this class' internal fields.
     */
    internal init() {
        coefficient = 1;
        constant = "";
    }
    
    
    //Parsing functions for initialization
    
    /**
     Parses text into a string of constants.  Throws and exception if there's an invalid character.
     Constants are interpreted as single characters, unless they're escaped with \.  A word escaped
     with \ is a single constant.  \ words are delimited by whitespace.
     
     Valid string: a \lambda \pi\stringConst abc
     Invalid string: a*NG
     
     Parameter text: to parse
     
     */
    internal static func parseConstants(_ text: String) -> [String] {
        var cons = [String]();
        let letters = CharacterSet.letters;
        let whitespace = CharacterSet.whitespaces;
        
        var current: String = "\\";
        var largeConst = false;
        
        for char in text.unicodeScalars {
            if char == "\\" {
                if largeConst {
                    cons.append(current);
                    current = "\\";
                } else {
                    largeConst = true;
                }
                
            } else if letters.contains(char) {
                if (largeConst) {
                    current += String(char);
                } else {
                    cons.append(String(char));
                }
            } else if whitespace.contains(char) {
                if (largeConst) {
                    largeConst = false;
                    cons.append(current);
                    current += "\\";
                }
            } else {
                
            }
        }
        
        return cons;
    }
    
    
    //************** Instance Methods *********
    internal func multiple(coefficient c: Int) -> Number {
        return Number(c, self.constant);
    }
    
    public func approximate() throws -> Double {
        if let c = Number.approximations[self.constant] {
            return c * Double(self.coefficient)
        } else {
            throw ApproximationError.UndefinedConstantError("'\(self.constant)' does not have a defined approximate decimal value."); 
        }
    }
    
    
    //*************** Operator instance methods ****************
    
    /**
     Number + Number
     
     Adds two basic numbers together
    */
    internal func add(_ right: Number) -> Number {
        switch right {
        case is Fraction: return (right as! Fraction).add(self)
        case is Sum: return (right as! Sum).add(self)
        case is Product: return (right as! Product).add(self)
        case is Exponential: return (right as! Exponential).add(self)
        default:
            break;
        }
        
        let left = self;
        if (left ~ right) {
            return Number(left.coefficient + right.coefficient, left.constant);
        } else {
            return Sum(left, right);
        }
    }
    
    /**
     Number * Number
     */
    internal func multiply(_ right: Number) -> Number {
        switch right {
        case is Fraction: return (right as! Fraction).multiply(self)
        case is Sum: return (right as! Sum).multiply(self)
        case is Product: return (right as! Product).multiply(self)
        case is Exponential: return (right as! Exponential).multiply(self)
        default:
            break;
        }
        //This case covers situations like 2 * 4, 2 * 4e, and 2e * 4
        if self.constant == "" || right.constant == "" {
            //Left's constant is the e, a, etc.
            if (self.constant != "") {
                return Number(self.coefficient * right.coefficient, self.constant);
                
                //right's constant is the e, a, etc. or they're both "".
            } else {
                return Number(self.coefficient * right.coefficient, right.constant);
            }
            
            
            //This case covers situations like 4e * e or 3a * 5a
        } else if self ~ right {
            return Exponential(coefficient: self.coefficient * right.coefficient, base: Number(self.constant), exponent: Number(2));
            
            //This case cover situations like 4e * 7b
        } else {
            return Product(coefficient: self.coefficient * right.coefficient, Number(self.constant), Number(right.constant));
        }
    }
    
    internal func equals(_ right: Number) -> Bool {
        switch right {
        case is Fraction: return (right as! Fraction).equals(self);
        case is Sum: return (right as! Sum).equals(self);
        case is Product: return (right as! Product).equals(self);
        case is Exponential: return (right as! Exponential).equals(self);
        default:
            if self.coefficient == 0 && right.coefficient == 0 {
                return true;
            }
            return self.coefficient == right.coefficient && self.constant == right.constant
        }
    }
    
    internal func lessthan(_ right: Number) -> Bool {
        if (self != right) {
            return self.constant < right.constant;
        } else {
            return self.coefficient < right.coefficient;
        }
    }
    
    /**
     Returns true if self is a multiple of the right number and differ only in coefficient; that is,
     they are like terms.
     
     Comparison is based on the string "constant" value.
     
     -Parameter right: The Number to compare to
     -Return true if the Numbers are like terms and false otherwise.
     */
    internal func like(_ right: Number) -> Bool {
        switch right {
        case is Fraction: return (right as! Fraction).like(self);
        case is Sum: return (right as! Sum).like(self);
        case is Product: return (right as! Product).like(self);
        case is Exponential: return (right as! Exponential).like(self);
        default: return self.constant == right.constant;
        }
    }
}

/**
 Adds together to Numbers.  This function handles the special case of 0, and does the appropriate downcasting
 to rout the call through the polymorphic add() function.
 */
public func + (left: Number, right: Number) -> Number {
    if left == Number(0) {
        return right;
    } else if right == Number(0) {
        return left;
    }
    
    switch left {
    case is Fraction: return (left as! Fraction).add(right)
    case is Product: return (left as! Product).add(right)
    case is Sum: return (left as! Sum).add(right)
    case is Exponential: return (left as! Exponential).add(right)
    default: return left.add(right)
    }
}

/**
 Subtracts two Numbers.  The call is routed through the + function.
 */
public func - (left: Number, right: Number) -> Number {
    return left + right.multiple(coefficient: -right.coefficient)
}

/**
 Multiplies together two Numbers. This function handles the special cases of zero and one, and does appropriate
 downcasting to rout the call through the polymorphic multiply() function.
 */
public func * (left: Number, right: Number) -> Number {
    //Handle special cases of zero and one.
    if left.coefficient == 0 || right.coefficient == 0 {
        return Number.zero;
    }
    
    if left == Number.one {
        return right
    } else if right == Number.one {
        return left
    }
    
    switch left {
    case is Fraction: return (left as! Fraction).multiply(right)
    case is Product: return (left as! Product).multiply(right)
    case is Sum: return (left as! Sum).multiply(right)
    case is Exponential: return (left as! Exponential).multiply(right)
    default: return left.multiply(right)
    }
}

/**
 Divides two Numbers. The call is routed through the / function.
 */
public func / (left: Number, right: Number) -> Number {
    if let r = right as? Fraction {
        return r.reciprocal().multiply(left)
    } else {
        return Fraction(Number(1), right).multiply(left)
    }
}

/**
 Raises the first Number to the power of the second Number.
 */
public func ^ (left: Number, right: Number) -> Number {
    if right.coefficient == 0 {
        return Number.one;
    } else if right == Number.one {
        return left;
    } else if left.coefficient == 0 {
        return Number.zero
    }
    
    var base: Number;
    var exp: Number;
    
    //This simulates raising an exponential to a power, such as
    // (x^2)^3
    if let e = left as? Exponential {
        base = e.base
        exp = e.base * right
        
    //This simulates normally raising something to a power (e.g. (x)^3
    } else {
        base = left
        exp = right
    }
    
    if exp ~ Number.one { //Exponent is an integer
        
    } else {
        if exp.coefficient < 0 {
            return Fraction(Number.one, Exponential(coefficient: base.coefficient, base: base.multiple(coefficient: 1), exponent: exp.multiple(coefficient: -exp.coefficient)))
        } else {
            return Exponential(coefficient: base.coefficient, base: base.multiple(coefficient: 1), exponent: exp)
        }
    }
}

/**
 Determines if two instances of Number or their subclasses are equal.
 */
public func == (left: Number, right: Number) -> Bool {
    switch left {
    case is Fraction: return (left as! Fraction).equals(right);
    case is Sum: return (left as! Sum).equals(right);
    case is Product: return (left as! Product).equals(right);
    case is Exponential: return (left as! Exponential).equals(right);
    default: return left.equals(right)
    }
}

/**
 Does an "expression comparison" for the two Numbers.  Because this module represents symbolic constants, such
 as x and y, which may not have a real value, doing a traditional numeric comparison doesn't make sense in many cases.
 Instead, this compares expressions lexiographically, so if used for sorting, like terms are next to eachother.
 
 A way to do a true numeric comparison would be the following:
 if let lessThan = try? m.approximate() < n.approximate() {
    if lessThan {
       //code
    } else {
       //code
    }
 } else {
    //code to handle UndefinedConstantError thrown by approximate.
 }
 */
public func < (lhs: Number, rhs: Number) -> Bool {
    let left = lhs is Fraction && ((lhs as! Fraction).denominator ~ Number.one) ? (lhs as! Fraction).numerator.multiple(coefficient: lhs.coefficient) : lhs;
    let right = rhs is Fraction && ((rhs as! Fraction).denominator ~ Number.one) ? (rhs as! Fraction).numerator.multiple(coefficient: rhs.coefficient) : rhs;
    
    if left is Exponential || right is Exponential {
        if let l = left as? Exponential {
            if let r = right as? Exponential {
                return l.base == r.base ? l.exponent < r.exponent : l.base < r.base;
            } else {
                return false;
            }
        } else if right is Exponential { //else to left as? Exponential.  Entered only if left is not an exponential and right is.
            return true;
        }
    }
    
    if left is Product || right is Product {
        if let l = left as? Product {
            if let r = right as? Product {
                
                //Products may have different numbers of coefficients; if so, the larger group of coefficients is sorted first.
                if l.factors.count < r.factors.count {
                    return true
                } else if l.factors.count > r.factors.count {
                    return false
                }
                
                //Compares each term in a coefficient; if the terms are the same; then the coefficients
                //are compared.
                for i in 0..<r.factors.count { //based on above if statement, arrays are the same length
                    if l.factors[i] != r.factors[i] {
                        return l.factors[i] < r.factors[i]
                    }
                }
                
                return l.coefficient < r.coefficient;
            } else {
                //All Products are considered greater than alternatives at this point.
                return false
            }
        } else { //else to let l = left as? Product.  Entered only if right is a Product and left is not.
            return true;
        }
    }
    
    if left is Sum || right is Sum {
        if let l = left as? Sum {
            if let r = right as? Sum {
                
                if l.terms.count < r.terms.count {
                    return true;
                } else if l.terms.count > r.terms.count {
                    return false;
                }
                
                for i in 0..<r.terms.count {
                    if l.terms[i] != r.terms[i] {
                        return l.terms[i] < r.terms[i]
                    }
                }
                
                return l.coefficient < r.coefficient
            } else {
                return false
            }
        } else { //This will only be entered if right is a Sum and left is not.
            return true;
        }
    }
    
    if left is Fraction || right is Fraction {
        if let l = left as? Fraction {
            if let r = right as? Fraction {
                //Compare by denominator
                if l.denominator != r.denominator {
                    return l.denominator < r.denominator
                }
                
                //Compare by numerator
                return l.numerator.multiple(coefficient: l.coefficient) < r.numerator.multiple(coefficient: r.coefficient)
            } else {
                //left is a fraction, right is not
                return false;
            }
        } else { //This will only be entered if right is a Fraction and left is not.
            return true;
        }
    }
    
    //comparison for basic Number.
    //Note that integers are compared only if constants are the same.
    if left.constant == right.constant {
        return left.coefficient < right.coefficient
    } else {
        return left.constant < right.constant
    }
}

/**
 The ~ operator is the "like" operator, which returns true if the left and right are like terms and false
 otherwise.  Like terms are within a constant factor of eachother.
 */
public func ~ (left: Number, right: Number) -> Bool {
    switch left {
    case is Fraction: return (left as! Fraction).like(right)
    case is Sum: return (left as! Sum).like(right)
    case is Product: return (left as! Product).like(right)
    case is Exponential: return (left as! Exponential).like(right)
    default: return left.like(right)
    }
}

/**
 Negates the result of the "like" operator.
 */
public func !~ (left: Number, right: Number) -> Bool {
    return !(left ~ right);
}
