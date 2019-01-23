//
//  Product.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 11/30/18.
//  Copyright © 2018 Luke Dramko. All rights reserved.
//

import Foundation

public class Product: Number {
    internal let factors: [Number];
    
    public override var hashValue: Int {
        var hash = coefficient;
        for factor in factors {
            hash = hash ^ factor.hashValue //xor used instead of multiplication
        }
        return hash
    }
    
    
    public override var description: String {
        var str = self.coefficient == 1 ? "" : "\(self.coefficient)";
        for i in 0..<(factors.count - 1) {
            if factors[i] is Sum {
                str += "(\(factors[i].description))"
            } else {
                str += factors[i].description
            }
        }
        
        if factors[factors.count - 1] is Sum {
            return "(" + str + factors[factors.count - 1].description + ")";
        } else {
            return str + factors[factors.count - 1].description;
        }
    }
    
    public override var LaTeX: String {
        var str: String;
        if self.coefficient == 1 {
            str = "";
        } else {
            str = String(self.coefficient);
        }
        for factor in factors {
            if factor is Sum {
                str += "(\(factor.LaTeX))"
            } else {
                str += factor.LaTeX;
            }
        }
        return str;
    }
    
    internal convenience init(coefficient: Int, _ n1: Number, _ n2: Number) {
        self.init(coefficient: coefficient, [n1, n2]);
    }
    
    internal convenience init(_ n1: Number, _ n2: Number) {
        self.init(coefficient: 1, [n1, n2]);
    }
    
    internal required init(coefficient: Int, _ inFactors: [Number]) {
        //factors are kept sorted for easy comparison and consistent display.
        factors = inFactors.sorted();
        super.init(coefficient);
    }
    
    //******************** Instance Methods ****************
    internal override func multiple(coefficient c: Int) -> Number {
        return Product(coefficient: c, self.factors)
    }
    
    public override func approximate() throws -> Double {
        var total: Double = Double(coefficient);
        
        for factor in factors {
            try total *= factor.approximate();
        }
        
        return total;
    }
    
    //********************** Operator Methods ***************
    /**
     Compares two products, and returns true if all of their factors and coefficients are equal, and false otherwise.
     
     Products are kept sorted, so comparison in order is acceptable.
     
     -Parameter right: the Product to compare this Product to
     -Return: true if all terms and coefficients are equal and false otherwise.
     */
    internal override func equals(_ right: Number) -> Bool {
        if self.coefficient == 0 && right.coefficient == 0 {
            return true;
        }
        
        if self.coefficient != right.coefficient {
            return false;
        }
        
        if let r = right as? Product {
            for i in 0..<factors.count {
                if !(self.factors[i] == r.factors[i]) {
                    return false
                }
                return true;
            }
        }
        return false;
    }
    
    /**
     Compares two Products, and returns true if all of their factors are equal, and false otherwise.
     
     Products are kept sorted, so comparison in order is acceptable.
     
     -Parameter right: the Product to compare this product to
     -Return: true if all terms are equal and false otherwise.
     */
    internal override func like(_ right: Number) -> Bool {
        if self.coefficient == 0 && right.coefficient == 0{
            return true;
        }
        
        if let r = right as? Product {
            return self.factors == r.factors;
        } else {
            return false;
        }
    }
    
    /**
     Product + Number
     
     Returns the sum of a Product and a Number.  If the Product and Number are like, terms are combined;
     otherwise, they are packaged into a Sum.
     
     -Parameter right: The right term of the sum.
     -Return: The result of the addition.
     */
    internal override func add(_ right: Number) -> Number {
        if self ~ right {
            let result = self.multiple(coefficient: self.coefficient + right.coefficient)
            
            if result == Number.zero {
                return Number.zero
            } else {
                return result
            }
        } else {
            return Sum(self, right)
        }
    }
    
    /**
     Product * Number
     
     Returns the product of a Number with another Number, including another poduct.
     
     -Parameter right: The right term of the product
     -Return: The result of the multiplication.
     */
    internal override func multiply(_ right: Number) -> Number {
        //self is a product; right is also a product.
        if let r = right as? Product {
            //dictionary nf relates the base of an exponent to its exponent.
            //For example, xy^2 is represented as [x:1, y:2]
            //nfh stands for "new factors hash"
            var nfh = Dictionary<Number, Number>();
            
            for f in self.factors {
                if let e = f as? Exponential {
                    nfh[e.base] = e.exponent
                } else {
                    nfh[f] = Number.one;
                }
            }
            
            for f in r.factors {
                if let e = f as? Exponential {
                    if let val = nfh[e.base] {
                        nfh[e.base] = val + e.exponent
                    } else {
                        nfh[e.base] = e.exponent
                    }
                } else { //f is not an Exponential
                    if let val = nfh[f] {
                        nfh[f] = val + Number.one
                    } else {
                        nfh[f] = Number.one
                    }
                }
            }
            
            //Stands for "new factors"
            var nf = Array<Number>();
            
            for (base, exponent) in nfh {
                if exponent == Number.one {
                    nf.append(base)
                } else {
                    nf.append(Exponential(base: base, exponent: exponent))
                }
            }
            
            return Product(coefficient: self.coefficient * r.coefficient, nf)
        }
        
        //right is not a product.
        
        if right ~ Number.one {
            return self.multiple(coefficient: self.coefficient * right.coefficient)
        }
        
        return self.multiply(Product(coefficient: right.coefficient, [right.multiple(coefficient: 1)]))
    }
}
