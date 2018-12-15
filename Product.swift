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
    
    internal convenience init(coefficient: Int, _ n1: Number, _ n2: Number) {
        self.init(coefficient: coefficient, [n1, n2]);
    }
    
    internal convenience init(_ n1: Number, _ n2: Number) {
        self.init(coefficient: 1, [n1, n2]);
    }
    
    internal required init(coefficient: Int, _ inFactors: [Number]) {
        factors = inFactors;
        super.init(coefficient);
    }
    
    //******************** Instance Methods ****************
    internal override func multiple(coefficient c: Int) -> Number {
        return Product(coefficient: c, self.factors)
    }
    
    
    
}
