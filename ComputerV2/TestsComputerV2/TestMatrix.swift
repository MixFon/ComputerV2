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
            let matrix = try! Matrix(expression: str)
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
            let temp = try? Matrix(expression: matrix)
            XCTAssertNil(temp, "\(String(describing: temp?.matrix))")
        }
    }
    
    func testOperatorPlus() throws {
        var one = try! Matrix(expression: "[[1,1];[2,2]]")
        var two = try! Matrix(expression: "[[4,4];[5,5]]")
        var three = try! Matrix(expression: "[[5,5];[7,7]]")
        XCTAssert((try! one + two) == three)
        
        one = try! Matrix(expression: "[[1,2,3];[4,5,6]]")
        two = try! Matrix(expression: "[[1,2,3];[4,5,6]]")
        three = try! Matrix(expression: "[[2,4,6];[8,10,12]]")
        XCTAssert((try! one + two) == three)
        
        one = try! Matrix(expression: "[[1.5];[4.76]]")
        two = try! Matrix(expression: "[[3.32];[7.45]]")
        three = try! Matrix(expression: "[[4.82];[12.21]]")
        XCTAssert((try! one + two) == three)
    }
    
    func testOperatorMinus() throws {
        var one = try! Matrix(expression: "[[1,1];[2,2]]")
        var two = try! Matrix(expression: "[[4,4];[5,5]]")
        var three = try! Matrix(expression: "[[-3,-3];[-3,-3]]")
        XCTAssert((try! one - two) == three)
        
        one = try! Matrix(expression: "[[1,2,3];[4,5,6]]")
        two = try! Matrix(expression: "[[1,2,3];[4,5,6]]")
        three = try! Matrix(expression: "[[0,0,0];[0,0,0]]")
        XCTAssert((try! one - two) == three)
        
        one = try! Matrix(expression: "[[1.5];[4.76]]")
        two = try! Matrix(expression: "[[3.32];[7.45]]")
        three = try! Matrix(expression: "[[-1.8199999999999998];[-2.6900000000000004]]")
        XCTAssert((try! one - two) == three)
    }
    
    func testOperatorMultiplicationMatrix() throws {
        var one = try! Matrix(expression: "[[1,2,3,4];[1,2,3,4];[1,2,3,4]]")
        var two = try! Matrix(expression: "[[4,5];[4,5];[4,5];[4,5]]")
        var three = try! Matrix(expression: "[[40,50];[40,50];[40,50]]")
        XCTAssert((try! one ** two) == three)
        
        one = try! Matrix(expression: "[[-1,2,-3,0];[5,4,-2,1];[-8,11,-10,-5]]")
        two = try! Matrix(expression: "[[-9,3];[6,20];[7,0];[12,-4]]")
        three = try! Matrix(expression: "[[0,37];[-23,91];[8,216]]")
        XCTAssert((try! one ** two) == three)
        
        one = try! Matrix(expression: "[[1.4]]")
        two = try! Matrix(expression: "[[4.1]]")
        three = try! Matrix(expression: "[[5.739999999999999]]")
        XCTAssert((try! one ** two) == three)
        
        one = try! Matrix(expression: "[[1.4,2.3,3.2,4.1];[1.9,2.8,3.7,4.6];[1.5,2.4,3.3,4.2]]")
        two = try! Matrix(expression: "[[4.1,5.2];[4.3,5.4];[4.5,5.6];[4.7,5.8]]")
        three = try! Matrix(expression: "[[49.3,61.39999999999999];[58.1,72.39999999999999];[51.06,63.599999999999994]]")
        XCTAssert((try! one ** two) == three)
    }
    
    func testOperatorAsterixTermToTerm() throws {
        var one = try! Matrix(expression: "[[1,2];[3,4]]")
        var two = try! Matrix(expression: "[[2,4];[6,8]]")
        XCTAssert( one * Rational(2) == two)
        
        one = try! Matrix(expression: "[[1.5];[4.76]]")
        two = try! Matrix(expression: "[[4.800000000000001];[15.232]]")
        XCTAssert( one * Rational(3.2) == two)
        
        one = try! Matrix(expression: "[[1,2,3,4];[1,2,3,4];[1,2,3,4]]")
        two = try! Matrix(expression: "[[1,2,3,4];[1,2,3,4];[1,2,3,4]]")
        var three = try! Matrix(expression: "[[1,4,9,16];[1,4,9,16];[1,4,9,16]]")
        XCTAssert((try! one * two) == three)
        
        one = try! Matrix(expression: "[[-1,2,-3,0];[5,4,-2,1];[-8,11,-10,-5]]")
        two = try! Matrix(expression: "[[1,2,3,4];[1,2,3,4];[1,2,3,4]]")
        three = try! Matrix(expression: "[[-1,4,-9,0];[5,8,-6,4];[-8,22,-30,-20]]")
        XCTAssert((try! one * two) == three)
        
        one = try! Matrix(expression: "[[1.4]]")
        two = try! Matrix(expression: "[[4.1]]")
        three = try! Matrix(expression: "[[5.739999999999999]]")
        XCTAssert((try! one * two) == three)
    }

    func testOperatorAsterixInvalid() throws {
        var one = try! Matrix(expression: "[[-1,2,-3,0];[5,4,-2,1];[-8,11,-10,-5]]")
        var two = try! Matrix(expression: "[[-9,3];[6,20];[7,0]]")
        var three = try? one ** two
        XCTAssertNil(three)
        
        one = try! Matrix(expression: "[[-1,2,-3,0];[5,4,-2,1];[-8,11,-10,-5]]")
        two = try! Matrix(expression: "[[-9,3];[6,20];[7,0];[12,-4];[12,-4];[12,-4]]")
        three = try? one ** two
        XCTAssertNil(three)
        
        one = try! Matrix(expression: "[[1.4,2.3]]")
        two = try! Matrix(expression: "[[4.1,5.2]]")
        three = try? one ** two
        XCTAssertNil(three)
    }
}
