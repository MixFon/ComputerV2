//
//  TestsImaginary.swift
//  TestsComputerV2
//
//  Created by Михаил Фокин on 08.03.2021.
//

import XCTest

//@testable import ComputerV2

class TestsImaginary: XCTestCase {
    
    var imaginaryNumber: Imaginary!

    override func setUpWithError() throws {
        imaginaryNumber = Imaginary()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        imaginaryNumber = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testConstructor() throws {
        imaginaryNumber = Imaginary()
        XCTAssert(imaginaryNumber.im == Rational() && imaginaryNumber.re == Rational())
        
        imaginaryNumber = Imaginary(imaginary: Rational(0.3), rational: Rational(0.6))
        XCTAssert(imaginaryNumber.im == Rational(0.3) &&
                    imaginaryNumber.re == Rational(0.6))
        
        let temp = Imaginary(imaginary: Rational(23), rational: Rational(234))
        imaginaryNumber = Imaginary(other: temp)
        XCTAssert(imaginaryNumber == temp)
    }
    
    func testOperatorsPlus() throws {
        // Оператор +
        imaginaryNumber = Imaginary(imaginary: Rational(3), rational: Rational(6)) +
            Imaginary(imaginary: Rational(5), rational: Rational(6))
        XCTAssert(imaginaryNumber == Imaginary(imaginary: 8.0, rational: 12.0))
        
        imaginaryNumber = Imaginary(imaginary: 0, rational: 4.5) +
            Imaginary(imaginary: 3.4, rational: 2.5)
        XCTAssert(imaginaryNumber == Imaginary(imaginary: 3.4, rational: 7.0))
        
        imaginaryNumber = Imaginary(imaginary: 123.4, rational: 73.6345) +
            Imaginary(imaginary: 4213.532, rational: 6234.634)
        XCTAssert(imaginaryNumber == Imaginary(imaginary: 4336.932, rational: 6308.2685))
    }
    
    func testOperatorsMinus() throws {
        // Оператор -
        imaginaryNumber = Imaginary(imaginary: Rational(3), rational: Rational(6)) -
            Imaginary(imaginary: Rational(5), rational: Rational(6))
        XCTAssert(imaginaryNumber == Imaginary(imaginary: -2.0, rational: 0.0))
        
        imaginaryNumber = Imaginary(imaginary: 0, rational: 4.5) -
            Imaginary(imaginary: 3.4, rational: 2.5)
        XCTAssert(imaginaryNumber == Imaginary(imaginary: -3.4, rational: 2.0))
        
        imaginaryNumber = Imaginary(imaginary: 123.4, rational: 73.6345) -
            Imaginary(imaginary: 4213.532, rational: 6234.634)
        XCTAssert(imaginaryNumber == Imaginary(imaginary: -4090.132, rational: -6160.9995))
    }
    
    func testOperatorsAsterix() throws {
        // Оператор *
        imaginaryNumber = Imaginary(imaginary: Rational(3), rational: Rational(6)) *
            Imaginary(imaginary: Rational(5), rational: Rational(6))
        XCTAssert(imaginaryNumber == Imaginary(imaginary: 48.0, rational: 21.0))
        
        imaginaryNumber = Imaginary(imaginary: 0, rational: 4.5) *
            Imaginary(imaginary: 3.4, rational: 2.5)
        XCTAssert(imaginaryNumber == Imaginary(imaginary: 15.299999999999999, rational: 11.25))
        
        imaginaryNumber = Imaginary(imaginary: 123.4, rational: 73.6345) *
            Imaginary(imaginary: 4213.532, rational: 6234.634)
        XCTAssert(Double(imaginaryNumber.im.rational) == 1079615.157654)
        XCTAssert(Double(imaginaryNumber.re.rational) == -60865.691527000046)
    }
    func testOperatorsDivision() throws {
        // Оператор /
        
        imaginaryNumber = try! Imaginary(imaginary: 34.142, rational: 3.523) /
            Imaginary(imaginary: 24.52, rational: 45.235)
        XCTAssert(Double(imaginaryNumber.im.rational) == 0.5507327151722528)
        XCTAssert(Double(imaginaryNumber.re.rational) == 0.37641132256048726)
        
        imaginaryNumber = try! Imaginary(imaginary: 4.0, rational: 3.0) /
            Imaginary(imaginary: 2.0, rational: 1.0)
        XCTAssert(Double(imaginaryNumber.im.rational) == -2/5)
        XCTAssert(Double(imaginaryNumber.re.rational) == 11/5)
    }
    
    func testOperatorsPow() throws {
        // Оператор ^
        imaginaryNumber = Imaginary(imaginary: 4.0, rational: 3.0) ^ 2
        XCTAssert(imaginaryNumber == Imaginary(imaginary: Rational(24), rational: Rational(-7)))
        
        imaginaryNumber = Imaginary(imaginary: 4.0, rational: 3.0) ^ 3
        XCTAssert(imaginaryNumber == Imaginary(imaginary: Rational(44), rational: Rational(-117)))
        
        imaginaryNumber = Imaginary(imaginary: 4.0, rational: 3.0) ^ 4
        XCTAssert(imaginaryNumber == Imaginary(imaginary: Rational(-336), rational: Rational(-527)))
        
        imaginaryNumber = Imaginary(imaginary: 12.42, rational: 657.234) ^ 2
        XCTAssert(imaginaryNumber.im.rational == 16325.692560000001)
        XCTAssert(imaginaryNumber.re.rational == 431802.274356)
        
        imaginaryNumber = Imaginary(imaginary: 12.42, rational: 657.234) ^ 3
        XCTAssert(imaginaryNumber.im.rational == 16092784.471480561)
        XCTAssert(imaginaryNumber.re.rational == 283592370.8824961)
        
        imaginaryNumber = Imaginary(imaginary: 12.42, rational: 657.234) ^ 23
        XCTAssert(imaginaryNumber.im.rational == 2.714336730240357e+64)
        XCTAssert(imaginaryNumber.re.rational == 5.847522507775276e+64)
        
        imaginaryNumber = Imaginary(imaginary: 12.42, rational: 657.234) ^ 10
        XCTAssert(imaginaryNumber.im.rational == 2.8296850655544243e+27)
        XCTAssert(imaginaryNumber.re.rational == 1.4797087596813364e+28)
        
    }

}
