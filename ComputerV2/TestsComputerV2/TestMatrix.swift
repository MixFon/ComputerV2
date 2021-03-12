//
//  TestMatrix.swift
//  TestsComputerV2
//
//  Created by Михаил Фокин on 12.03.2021.
//

import XCTest

@testable import ComputerV2

class TestMatrix: XCTestCase {
    
    var matrix: Matrix!

    override func setUpWithError() throws {
        matrix = Matrix()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        matrix = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testConstructor() throws {
        let matrixDouble = [
            [[1.0,3],[2,4],[5,7]],
            [[1,3],[2,4]],
            [[1,3]],
            [[1,5]],
            [[1,3,4],[2,4,6],[1,2,3]],
            [[1],[2],[3],[4]]
        ]
        for matrixD in matrixDouble {
            var str = "\(matrixD)"
            str = str.replace(string: "], ", replacement: "];").removeWhitespace()
            let matrix = try! Matrix(matrix: str)
            for (i, row) in matrix.matrix.enumerated() {
                for (j, elem) in row.enumerated() {
                    XCTAssert(matrixD[i][j] == elem.rational, "\(matrixD[i][j]) == \(elem.rational)")
                }
            }
            matrix.printMatrix()
            print(str)
        }
    }
    
    func testInvalidMatrix() throws {
        let matrixs = [
            "[[1.0,3];[2,4][5,7]]",
            "[[1,];[2,4]]",
            "[[,3]]",
            "[[4,3];[,,3]]",
            "[[]]",
            "[[1,3,4];[2,4,6];[1,2,3}]",
            "[(1];[2];[3];[4]]",
            "[[1];[2];[3];[4,,]]",
            "[[1,3];[2,2];[3,3];[4,3,8]]",
            "[[1,3];[2,2];[3,3];[4]]",
            "[[A,3];[2,2];[3,3];[4,6]]",
            "[[1,3];[2,2];[3,3];[]]",
            "[[1,3];[2,2];[3,3];[4..4,4]]"
        ]
        for matrix in matrixs {
            let temp = try? Matrix(matrix: matrix)
            XCTAssertNil(temp, "\(String(describing: temp?.matrix))")
        }
    }
    
    func testOperatorPlus() throws {
        var one = try! Matrix(matrix: "[[1,1];[2,2]]")
        var two = try! Matrix(matrix: "[[4,4];[5,5]]")
        var three = try! Matrix(matrix: "[[5,5];[7,7]]")
        XCTAssert((try! one + two) == three)
        
        one = try! Matrix(matrix: "[[1,2,3];[4,5,6]]")
        two = try! Matrix(matrix: "[[1,2,3];[4,5,6]]")
        three = try! Matrix(matrix: "[[2,4,6];[8,10,12]]")
        XCTAssert((try! one + two) == three)
        
        one = try! Matrix(matrix: "[[1.5];[4.76]]")
        two = try! Matrix(matrix: "[[3.32];[7.45]]")
        three = try! Matrix(matrix: "[[4.82];[12.21]]")
        XCTAssert((try! one + two) == three)
    }
    
    func testOperatorMinus() throws {
        var one = try! Matrix(matrix: "[[1,1];[2,2]]")
        var two = try! Matrix(matrix: "[[4,4];[5,5]]")
        var three = try! Matrix(matrix: "[[-3,-3];[-3,-3]]")
        XCTAssert((try! one - two) == three)
        
        one = try! Matrix(matrix: "[[1,2,3];[4,5,6]]")
        two = try! Matrix(matrix: "[[1,2,3];[4,5,6]]")
        three = try! Matrix(matrix: "[[0,0,0];[0,0,0]]")
        XCTAssert((try! one - two) == three)
        
        one = try! Matrix(matrix: "[[1.5];[4.76]]")
        two = try! Matrix(matrix: "[[3.32];[7.45]]")
        three = try! Matrix(matrix: "[[-1.8199999999999998];[-2.6900000000000004]]")
        XCTAssert((try! one - two) == three)
    }
    
    func testOperatorAsterix() throws {
        var one = try! Matrix(matrix: "[[1,2];[3,4]]")
        var two = try! Matrix(matrix: "[[2,4];[6,8]]")
        var three = try! Matrix(matrix: "[[-3,-3];[-3,-3]]")
        XCTAssert( one * Rational(2) == two)
        
        one = try! Matrix(matrix: "[[1.5];[4.76]]")
        two = try! Matrix(matrix: "[[4.800000000000001];[15.232]]")
        print((one * Rational(3.2)).matrix)
        XCTAssert( one * Rational(3.2) == two)
        
        one = try! Matrix(matrix: "[[1,2,3,4];[1,2,4,5];[1,2,4,5]]")
        two = try! Matrix(matrix: "[[1,2];[4,5];[4,5];[4,5]]")
        three = try! Matrix(matrix: "[[0,0,0];[0,0,0]]")
        XCTAssert((try! one * two) == three)
    }

}
