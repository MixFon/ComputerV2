//
//  TestsComputerV2.swift
//  TestsComputerV2
//
//  Created by Михаил Фокин on 05.03.2021.
//

import XCTest

@testable import ComputerV2

class TestsComputerV2: XCTestCase {
    
    var computer: Computer!

    override func setUpWithError() throws {
        computer = Computer()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        computer = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        var infixForm = "3 + 4 * 2 / (1 - 5)^2".removeWhitespace()
        var postfixFomr = "3 4 2 * 1 5 - 2 ^ / +"
        XCTAssertEqual(computer.conversionPostfixForm(line: infixForm), postfixFomr)
        infixForm = "(21 * 2)^42-(12 * 2)^23+32*5".removeWhitespace()
        postfixFomr = "21 2 * 42 ^ 12 2 * 23 ^ - 32 5 * +"
        XCTAssertEqual(computer.conversionPostfixForm(line: infixForm), postfixFomr)
        infixForm = "x ^ y / (5 * z) + 10".removeWhitespace()
        postfixFomr = "x y ^ 5 z * / 10 +"
        XCTAssertEqual(computer.conversionPostfixForm(line: infixForm), postfixFomr)
        infixForm = "(32 * 2)^23*3+3".removeWhitespace()
        postfixFomr = "32 2 * 23 ^ 3 * 3 +"
        XCTAssertEqual(computer.conversionPostfixForm(line: infixForm), postfixFomr)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
