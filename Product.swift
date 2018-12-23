//
//  Product.swift
//  NumbersDevelop
//
//  Created by Luke  Dramko on 11/30/18.
//  Copyright © 2018 Luke Dramko. All rights reserved.
//

import Foundation

public class Product: Number {
    private let factors: [Number];
    public override var description: String {
        var str = "(";
        for i in 0..<(factors.count - 1) {
            str += factors[i].description + "*";
        }
        return str + factors[factors.count - 1].description + ")";
    }
    
    public override var LaTeX: String {
        var str = "";
        for factor in factors {
            str += factor.LaTeX;
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
}
