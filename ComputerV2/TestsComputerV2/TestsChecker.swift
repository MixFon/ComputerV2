//
//  TestsChecker.swift
//  TestsComputerV2
//
//  Created by Михаил Фокин on 11.03.2021.
//

import XCTest

class TestsChecker: XCTestCase {
    var checker: Checker!

    override func setUpWithError() throws {
        checker = Checker()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        checker = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBreckets() throws {
        var line = [
            "(){}[]",
            "([{}])",
            "([{}])",
            "({})[({})]",
            "(({{[[]]}}))",
            "{}({})[]",
            "{2+3}*({3-1})/[23^2]",
            "[[3]]"
        ]
        for line in line {
            let temp: ()? = try? checker.checkBreckets(line: line)
            XCTAssertTrue((temp != nil))
        }
        line = [
            "(}",
            "[(])",
            "(})",
            "[({})](]",
            ")(}{][",
            "())({}}{()][][",
            "(((({{",
            "}}]]))}])"
        ]
        for line in line {
            let temp: ()? = try? checker.checkBreckets(line: line)
            XCTAssertNil(temp)
        }
    }
    
    func testInputLine() throws {
        var line = [
            "(2+3)^3+4*{s^3+2}*[3+3]",
            "((3+3)^3+3)*3)",
            "((6-3))",
            "((3+3)^3*3+(3+2)",
            "((3+3)^(3+3))*3+(3+2)",
            "((3+4)^(5-6))*7+(9/8)",
            "[[1,3];[2,4];[5,7]]"
        ]
        for line in line {
            let temp: ()? = try? checker.checkLine(line: line)
            XCTAssertTrue(temp != nil, line)
        }
        line = [
            "(3*4)(3*5)",
            "(3*)+",
            "()",
            ")(",
            "[]",
            "][",
            "(*)",
            "(*+)",
            "(3+4+)+2",
            "(3+4-)+",
            "(3+4/)/0",
            "(3+4%)-3",
            "(3+4*)#3",
            ")*)",
            "3--*4",
            "3--4",
            "3-.-4",
            "3+4++",
            "(4+3-3***3)",
            "3^^4",
            "(*(",
            "[[1,3][2,4];[5,7]]",
            "[[1,3];[2,4];]",
        ]
        for line in line {
            let temp: ()? = try? checker.checkLine(line: line)
            XCTAssertNil(temp, line)
        }
    }
    
        

}
