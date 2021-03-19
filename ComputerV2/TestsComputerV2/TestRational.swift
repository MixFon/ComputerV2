//
//  TestRational.swift
//  TestsComputerV2
//
//  Created by Михаил Фокин on 07.03.2021.
//

import XCTest

//@testable import ComputerV2

class TestRational: XCTestCase {
    var one: Rational!
    var two: Rational!
    var three: Rational!

    override func setUpWithError() throws {
        one = Rational()
        two = Rational()
        three = Rational()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        one = nil
        two = nil
        three = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCostructor() throws {
        
        // Кончтруктор по умолчани.
        let one = Rational()
        XCTAssert(one.rational == 0)
        
        // Коструктор копирования
        let three = Rational(9.0932)
        XCTAssert(three.rational == 9.0932)
        
        // Конструктор с десятичным аргументом
        var four = Rational(0.5)
        XCTAssert(four.rational == 0.5)
        
        four = Rational(1.7)
        XCTAssert(four.rational == 1.7)
        
        four = Rational(0.007)
        XCTAssert(four.rational == 0.007)
    }
    
    func testOperatorsPlus() throws {
        // Оператор +
        var one = Rational(0.5)
        var two = Rational(0.25)
        var three = one + two
        XCTAssert(three.rational == 0.75)
        
        one = Rational(14/13)
        two = Rational(12/13)
        three = one + two
        XCTAssert(three.rational == 2)
        
        one = Rational(4)
        two = Rational(8)
        three = one + two
        XCTAssert(three.rational == 12)
    }
    
    func testOperatorsMinus() throws {
        // Оператор -
        one = Rational(4)
        two = Rational(8)
        three = one - two
        XCTAssert(three.rational == -4)
        
        one = Rational(7.25)
        two = Rational(0.25)
        three = one - two
        XCTAssert(three.rational == 7)
        
        one = Rational(-4)
        two = Rational(8)
        three = one - two
        XCTAssert(three.rational == -12)
    }
    
    func testOperatorsAsterux() throws {
        // Оператор *
        one = Rational(-4)
        two = Rational(8)
        three = one * two
        XCTAssert(three.rational == -32)
        
        one = Rational(0.25)
        two = Rational(4)
        three = one * two
        XCTAssert(three.rational == 1)
        
        one = Rational(0.5)
        two = Rational(0.5)
        three = one * two
        XCTAssert(three.rational == 0.25)
    }
    
    func testOperatorsDivision() throws {
        // Оператор /
        one = Rational(24)
        two = Rational(8)
        three = try! one / two
        XCTAssert(three.rational == 3)
        
        one = Rational(5.5)
        two = Rational(0.5)
        three = try! one / two
        XCTAssert(three.rational == 11)
        
        one = Rational(0.5)
        two = Rational(0)
        XCTAssertNil(try? one / two)
    }
    
    func testOperatorsRemainder() throws {
        // Оператор %
        one = Rational(7.9)
        two = Rational(2.1)
        three = try! one % two
        print(three.fraction)
        print(three.rational)
        XCTAssert(three! == Rational(1.5999999999999996))
        
        one = Rational(3.5)
        two = Rational(1.3)
        three = try! one % two
        print(three.fraction)
        print(three.rational)
        XCTAssert(three! == Rational(0.8999999999999999))
        
        one = Rational(4.0)
        two = Rational(3.0)
        three = try! one % two
        XCTAssert(three! == Rational(1.0))
        
        one = Rational(4.0)
        two = Rational(2.0)
        three = try! one % two
        XCTAssert(three! == Rational(0.0))
    }
    
    func testOperatorsPow() throws {
        // Оператор ^
        one = Rational(4.0)
        two = Rational(3.0)
        three = try! one ^ two
        XCTAssert(three! == Rational(64.0))
        
        one = Rational(4.3)
        two = Rational(2.0)
        three = try! one ^ two
        XCTAssert(three! == Rational(18.49))
        
        one = Rational(4.0)
        two = Rational(3.0)
        three = try! one ^ two
        XCTAssert(three! == Rational(64.0))
        
        one = Rational(43.3)
        two = Rational(3.0)
        three = try! one ^ two
        XCTAssert(three! == Rational(81182.73699999998))
        
        one = Rational(123.415)
        two = Rational(4.0)
        three = try! one ^ two
        print(three!)
        XCTAssert(three!.rational == 231991348.966712)
    }
    
    func testSqrt() throws {
        var one = Rational(4)
        XCTAssert(sqrt(rational: one).rational == 2)
        
        one = Rational(16.25)
        XCTAssert(sqrt(rational: one).rational == 4.0311288741492748)
        
        one = Rational(-16.25)
        print(sqrt(rational: one))
        XCTAssert(sqrt(rational: one).rational.isNaN)
    }
}
