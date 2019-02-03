//
//  ExpressionsTests.swift
//  ExpressionsTests
//
//  Created by Luke  Dramko on 1/30/19.
//  Copyright © 2019 Luke Dramko. All rights reserved.
//

import XCTest
@testable import Expressions

infix operator ^

class ExpressionsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDevelopment() {
        //Test method for continuous testing
        let x = try! Expressions.simplify("(3xy^(1/2) + 3x^2y^(1/2))(x + 3)/(3a)")
        print(x)
        let y = try! Expressions.simplify("xyz^2/(4x)")
        print(y)
    }
    
    func testSimplifyLargeExpression() {
        let x = try! Expressions.simplify("(3xy^(1/2) + 3x^2y^(1/2))(x + 3)/(3a)")
        XCTAssert(x.LaTeX == "\\frac{3x\\sqrt{y}+4x^{2}\\sqrt{y}+x^{3}\\sqrt{y}}{a}")
    }
    
    func testApproximations() {
        Expressions.setApproximation(of: "a", to: 1.5)
        let x = try! Expressions.simplify("e^(4^(1/2))*a").approximate();
        
        //Testing inside a range due to imprecision of floating point numbers.
        XCTAssert(x > 11.083584 && x < 11.083585)
    }
    
    func testReduce() {
        let x = try! Expressions.simplify("xyz^2/(4x)")
        let y = try! Expressions.simplify("(3y^(1/2) + 3xy^(1/2))(x + 3)/(3ay^(1/2))")
        XCTAssert(x.description == "y(z)^(2)/4")
        XCTAssert(y.LaTeX == "\\frac{3+4x+x^{2}}{a}")
    }

    func testPerformanceLargeExpression() {
        
        self.measure {
            let _ = try! Expressions.simplify("(3xy^(1/2) + 3x^2y^(1/2))(x + 3)/(3a)")
        }
    }

}
