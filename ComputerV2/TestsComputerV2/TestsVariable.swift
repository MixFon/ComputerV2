//
//  TestsVariable.swift
//  TestsComputerV2
//
//  Created by Михаил Фокин on 15.03.2021.
//

import XCTest

class TestsVariable: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNewVariable() throws {
        let varioble = Variable(name: "varA")
        let matrix = try! Rational(expression: "3.5")
        varioble.value = matrix
    }

}
