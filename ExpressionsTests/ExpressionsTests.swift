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
        print(Sum(Number("x"), Number.one) ^ Number(2))
        print(try! Expressions.simplify("(x + 1)^2"))
    }
    
    func testSimplifyLargeExpression() {
        let x = try! Expressions.simplify("(3xy^(1/2) + 3x^2y^(1/2))(x + 3)/(3a)")
        XCTAssert(x.LaTeX == "\\frac{3x\\sqrt{y}+4x^{2}\\sqrt{y}+x^{3}\\sqrt{y}}{a}")
    }

    func testPerformanceLargeExpression() {
        // This is an example of a performance test case.
        self.measure {
            let _ = try! Expressions.simplify("(3xy^(1/2) + 3x^2y^(1/2))(x + 3)/(3a)")
        }
    }

}
