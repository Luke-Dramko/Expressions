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
     Number - Number
     */
    internal func subtract(_ right: Number) -> Number {
        switch right {
        case is Fraction: return (right.multiple(coefficient: -right.coefficient) as! Fraction).add(self)
        case is Sum: return (right.multiple(coefficient: -right.coefficient) as! Sum).add(self)
        case is Product: return (right.multiple(coefficient: -right.coefficient) as! Product).add(self)
        case is Exponential: return (right.multiple(coefficient: -right.coefficient) as! Exponential).add(self)
        default:
            break;
        }
        let left = self;
        if left ~ right {
            return Number(left.coefficient - right.coefficient, left.constant);
        } else {
            return Sum(left, Number(-right.coefficient, right.constant));
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
    
    /**
     Number / Number
     */
    internal func divide(_ right: Number) -> Number {
        switch right {
        case is Fraction:
            //self / right = (1/right * self)
            
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
            return Fraction(c, r.denominator.multiple(coefficient: 1), r.numerator.multiple(coefficient: r.coefficient)).multiply(self)
        case is Sum: return Fraction(Number(1), right).multiply(self)
        case is Product: return Fraction(Number(1), right).multiply(self)
        case is Exponential: return Fraction(Number(1), right).multiply(self)
        default:
            break;
        }
        
        let left = self;
        let g = gcd(left.coefficient, right.coefficient);
        let n: Int = left.coefficient / g; //numerator
        let d: Int = right.coefficient / g; //denominator
        
        //Handles cases such as 5/4, e/e, 1/2, and 6e/7e
        if left ~ right {
            if d == 1 {
                return Number(n);
            } else {
                return Fraction(n, Number(1), Number(d));
            }
            
            //Handles any case in which the numerator and denominator have different symbolic constants,
            //such as 3/a 2t/x, etc.
        } else {
            return Fraction(n, Number(left.constant), Number(d, right.constant))
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
 Subtracts two Numbers.  The call is routed through the subtract() function in Number.
 */
public func - (left: Number, right: Number) -> Number {
    return left.subtract(right)
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
 Divides two Numbers.  The call is routed through the divide() function in Number.
 */
public func / (left: Number, right: Number) -> Number {
    if left.coefficient == 0 {
        return Number.zero
    }
    return left.divide(right)
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
 as x and y, which may not have a value, doing a traditional numeric comparison doesn't make sense in many cases.
 Instead, this compares expressions lexiographically, so if used for sorting, like terms are next to eachother.
 
 When there is an obvious and deterministic way to compare two Numbers (i.e. Number(2) < Number(4)), the correct
 result is returned, but this function does NOT take into consideration the values of constants set as
 approximateions, such as e and pi.
 
 A way to do a true numeric comparison would be the following:
 if let lessThan = try? m.approximate() < n.approximate() {
    if lessThan {
       //code
    } else {
       //code
    }
 } else {
    //code
 }
 */
public func < (lhs: Number, rhs: Number) -> Bool {
    return lhs.lessthan(rhs)
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
