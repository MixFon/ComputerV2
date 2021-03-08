//
//  TestsImaginary.swift
//  TestsComputerV2
//
//  Created by Михаил Фокин on 08.03.2021.
//

import XCTest

@testable import ComputerV2

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
        XCTAssert(imaginaryNumber == Imaginary(imaginary: 15.3, rational: 11.25))
        
        imaginaryNumber = Imaginary(imaginary: 123.4, rational: 73.6345) *
            Imaginary(imaginary: 4213.532, rational: 6234.634)
        print(imaginaryNumber.im.decimalView, imaginaryNumber.im.rationalView)
        print(imaginaryNumber.re.decimalView, imaginaryNumber.re.rationalView)
        XCTAssert(Double(imaginaryNumber.im.decimalView) == 1079615.157654)
        XCTAssert(Double(imaginaryNumber.re.decimalView) == -60865.69152699998)
    }
    func testOperatorsDivision() throws {
        // Оператор /
        imaginaryNumber = Imaginary(imaginary: Rational(3), rational: Rational(6)) /
            Imaginary(imaginary: Rational(5), rational: Rational(6))
        XCTAssert(imaginaryNumber == Imaginary(imaginary: try! Rational(numeratorInt: -12, denominatorInt: 61),
                                               rational: try! Rational(numeratorInt: 51, denominatorInt: 61)))
        
        imaginaryNumber = Imaginary(imaginary: 3.6, rational: 4.5) /
            Imaginary(imaginary: 3.4, rational: 2.5)
        XCTAssert(imaginaryNumber == Imaginary(imaginary: try! Rational(numeratorInt: -630, denominatorInt: 1781),
                                               rational: try! Rational(numeratorInt: 2349, denominatorInt: 1781)))
        
        imaginaryNumber = Imaginary(imaginary: 34.142, rational: 3.523) /
            Imaginary(imaginary: 24.52, rational: 45.235)
        XCTAssert(Double(imaginaryNumber.im.decimalView) == 0.5507327151299668)
        XCTAssert(Double(imaginaryNumber.re.decimalView) == 0.37641132256516874)
        
        imaginaryNumber = Imaginary(imaginary: 4.0, rational: 3.0) /
            Imaginary(imaginary: 2.0, rational: 1.0)
        XCTAssert(Double(imaginaryNumber.im.decimalView) == -2/5)
        XCTAssert(Double(imaginaryNumber.re.decimalView) == 11/5)
    }
    
    func testOperatorsPow() throws {
        // Оператор ^
        imaginaryNumber = (try! Imaginary(imaginary: 4.0, rational: 3.0) ^ 2)
        XCTAssert(imaginaryNumber == Imaginary(imaginary: Rational(24), rational: Rational(-7)))
        
        imaginaryNumber = (try! Imaginary(imaginary: 4.0, rational: 3.0) ^ 3)
        XCTAssert(imaginaryNumber == Imaginary(imaginary: Rational(44), rational: Rational(-117)))
        
        imaginaryNumber = (try! Imaginary(imaginary: 4.0, rational: 3.0) ^ 4)
        XCTAssert(imaginaryNumber == Imaginary(imaginary: Rational(-336), rational: Rational(-527)))
        
        imaginaryNumber = (try! Imaginary(imaginary: 12.42, rational: 657.234) ^ 2)
//        print(imaginaryNumber.im.rationalView, imaginaryNumber.im.decimalView)
//        print(imaginaryNumber.re.rationalView, imaginaryNumber.re.decimalView)
        XCTAssert(imaginaryNumber.im.decimalView == 16325.69256 &&
                    imaginaryNumber.re.decimalView == 431802.27435599995)
        imaginaryNumber = (try! Imaginary(imaginary: 12.42, rational: 657.234) ^ 3)
//        print(imaginaryNumber.im.rationalView, imaginaryNumber.im.decimalView)
//        print(imaginaryNumber.re.rationalView, imaginaryNumber.re.decimalView)
        XCTAssert(imaginaryNumber.im.decimalView == 16092784.47148056 &&
                    imaginaryNumber.re.decimalView == 283592370.88249606)
        
        imaginaryNumber = (try! Imaginary(imaginary: 12.42, rational: 657.234) ^ 23)
        print(imaginaryNumber.im.rationalView, imaginaryNumber.im.decimalView)
        print(imaginaryNumber.re.rationalView, imaginaryNumber.re.decimalView)
        XCTAssert(imaginaryNumber.im.decimalView == 11578742794895.352 &&
                    imaginaryNumber.re.decimalView == 122193104885356.33)
    }

}
