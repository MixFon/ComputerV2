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

    func testPostfixForm() throws {
        let testDict = [
            "3 + 4 * 2 / (1 - 5)^2".removeWhitespace(): "3 4 2 * 1 5 - 2 ^ / +" ,
            "(21 * 2)^42-(12 * 2)^23+32*5".removeWhitespace(): "21 2 * 42 ^ 12 2 * 23 ^ - 32 5 * +" ,
            "x ^ y / (5 * z) + 10".removeWhitespace(): "x y ^ 5 z * / 10 +" ,
            "(32 * 2)^23*3+3".removeWhitespace(): "32 2 * 23 ^ 3 * 3 +",
            "((3+4)^(5-6))*7+(9/ 8)".removeWhitespace(): "3 4 + 5 6 - ^ 7 * 9 8 / +"
            
        ]
        for elem in testDict {
            XCTAssertEqual(computer.conversionPostfixForm(infixFomr: elem.key), elem.value)
        }
    }

    func testCalculateDoubleValue() throws {
        let testDict = [
            "1 + 3".removeWhitespace(): 4.0,
            "3 * 4".removeWhitespace(): 12.0,
            "4 / 2".removeWhitespace(): 2.0,
            "12 ^ 2".removeWhitespace(): 144.0,
            "2 + 2 * 2".removeWhitespace(): 6.0,
            "(2 + 2) * 2".removeWhitespace(): 8.0,
            "3 + 4 * 2 / (1 - 5)^2".removeWhitespace(): 3.5,
            "(21 * 2)^2-(12 * 2)^3+32*5".removeWhitespace(): -11900,
            "(32 * 2)^4*3+3".removeWhitespace(): 50331651,
            "(3^2 + 3^4)/(2^4 / 3 - 4^3*4)^2".removeWhitespace(): 0.001432350611136261,
            "5^4^3^2".removeWhitespace(): 59604644775390625.0
        ]
        for elem in testDict {
            let posfixForm = computer.conversionPostfixForm(infixFomr: elem.key)
            let result = try computer.calculateValue(postfixForm: posfixForm)
            XCTAssertEqual(result, elem.value)
        }
    }
    
    func testFails() throws {
        let testString = [
            "1 + **3".removeWhitespace(),
            "1 +*3".removeWhitespace(),
            "+++3".removeWhitespace(),
            "3+++".removeWhitespace(),
            "+++".removeWhitespace(),
            "+".removeWhitespace(),
            "++".removeWhitespace(),
            "34 / 0".removeWhitespace(),
            "2+ 3 *3**4".removeWhitespace(),
            "2+-3*3*4".removeWhitespace(),
            "2--3^3**4".removeWhitespace(),
            "2+3*3+(4 + 4/0)".removeWhitespace()
        ]
        for elem in testString {
            let posfixForm = computer.conversionPostfixForm(infixFomr: elem)
            let result = try? computer.calculateValue(postfixForm: posfixForm)
            XCTAssertNil(result)
        }
    }

}
