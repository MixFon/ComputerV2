//
//  TestRational.swift
//  TestsComputerV2
//
//  Created by Михаил Фокин on 07.03.2021.
//

import XCTest

@testable import ComputerV2

class TestRational: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCostructor() throws {
        
        // Кончтруктор по умолчани.
        let one = Rational()
        XCTAssert(one.numerator == 0 && one.denominator == 1)
        
        // Коструктор с числителем и знаменателем
        var two = try! Rational(numeratorInt: 12, denominatorInt: 24)
        XCTAssert(two.numerator == 1 && two.denominator == 2)
        
        two = try! Rational(numeratorInt: 3, denominatorInt: 7)
        XCTAssert(two.numerator == 3 && two.denominator == 7)
        
        two = try! Rational(numeratorInt: 6, denominatorInt: 2)
        XCTAssert(two.numerator == 3 && two.denominator == 1)
        
        two = try! Rational(numeratorInt: 1, denominatorInt: 7)
        XCTAssert(two.numerator == 1 && two.denominator == 7)
        
        two = try! Rational(numeratorInt: 3, denominatorInt: 7)
        XCTAssert(two.numerator == 3 && two.denominator == 7)
        
        var three = try? Rational(numeratorInt: 4, denominatorInt: 0)
        XCTAssertNil(three)
        
        // Коструктор копирования
        three = Rational(other: two)
        XCTAssert(three!.numerator == 3 && three!.denominator == 7)
        
        // Конструктор с десятичным аргументом
        var four = Rational(0.5)
        XCTAssert(four.numerator == 1 && four.denominator == 2)
        
        four = Rational(1.7)
        XCTAssert(four.numerator == 17 && four.denominator == 10)
        
        four = Rational(0.007)
        XCTAssert(four.numerator == 7 && four.denominator == 1000)
        
        four = Rational(0.7)
        XCTAssert(four.numerator == 7 && four.denominator == 10)
        
        four = Rational(0.333)
        XCTAssert(four.numerator == 333 && four.denominator == 1000)
        
        four = Rational(2.25)
        XCTAssert(four.numerator == 9 && four.denominator == 4)
        
        four = Rational(1.5)
        XCTAssert(four.numerator == 3 && four.denominator == 2)
    }
    
    func testOperators() throws {
        // Оператор +
        var one = try! Rational(numeratorInt: 4, denominatorInt: 7)
        var two = try! Rational(numeratorInt: 5, denominatorInt: 9)
        var three = one + two
        XCTAssert(three.numerator == 71 && three.denominator == 63)
        
        one = try! Rational(numeratorInt: 14, denominatorInt: 13)
        two = try! Rational(numeratorInt: 2, denominatorInt: 3)
        three = one + two
        XCTAssert(three.numerator == 68 && three.denominator == 39)
        
        one = try! Rational(numeratorInt: 4, denominatorInt: 6)
        two = try! Rational(numeratorInt: 14, denominatorInt: 4)
        three = one + two
        XCTAssert(three.numerator == 25 && three.denominator == 6)
        
        // Оператор -
        one = try! Rational(numeratorInt: 15, denominatorInt: 6)
        two = try! Rational(numeratorInt: 5, denominatorInt: 15)
        three = one - two
        XCTAssert(three.numerator == 13 && three.denominator == 6)
        
        one = try! Rational(numeratorInt: 134, denominatorInt: 123)
        two = try! Rational(numeratorInt: 15, denominatorInt: 85)
        three = one - two
        XCTAssert(three.numerator == 1909 && three.denominator == 2091)
        
        one = try! Rational(numeratorInt: 12, denominatorInt: 2)
        two = try! Rational(numeratorInt: 18, denominatorInt: 6)
        three = one - two
        XCTAssert(three.numerator == 3 && three.denominator == 1)
        
        // Оператор *
        one = try! Rational(numeratorInt: 15, denominatorInt: 6)
        two = try! Rational(numeratorInt: 5, denominatorInt: 15)
        three = one * two
        XCTAssert(three.numerator == 5 && three.denominator == 6)
        
        one = try! Rational(numeratorInt: 134, denominatorInt: 123)
        two = try! Rational(numeratorInt: 15, denominatorInt: 85)
        three = one * two
        XCTAssert(three.numerator == 134 && three.denominator == 697)
        
        one = try! Rational(numeratorInt: 12, denominatorInt: 2)
        two = try! Rational(numeratorInt: 18, denominatorInt: 6)
        three = one * two
        XCTAssert(three.numerator == 18 && three.denominator == 1)
        
        // Оператор /
        one = try! Rational(numeratorInt: 15, denominatorInt: 6)
        two = try! Rational(numeratorInt: 5, denominatorInt: 15)
        print(two)
        three = try! one / two
        
        XCTAssert(three.numerator == 15 && three.denominator == 2)
        
        one = try! Rational(numeratorInt: 134, denominatorInt: 123)
        two = try! Rational(numeratorInt: 15, denominatorInt: 85)
        three = try! one / two
        XCTAssert(three.numerator == 2278 && three.denominator == 369)
        
        one = try! Rational(numeratorInt: 12, denominatorInt: 2)
        two = try! Rational(numeratorInt: 18, denominatorInt: 6)
        three = try! one / two
        XCTAssert(three.numerator == 2 && three.denominator == 1)
        
        // Оператор %
        one = Rational(7.9)
        two = Rational(2.1)
        three = try! one % two
        XCTAssert(three == Rational(1.6))
        
        one = Rational(4.0)
        two = Rational(3.0)
        three = try! one % two
        XCTAssert(three == Rational(1.0))
        
        one = Rational(4.0)
        two = Rational(2.0)
        three = try! one % two
        XCTAssert(three == Rational(0.0))
        
        // Оператор ^
        one = Rational(4.0)
        two = Rational(3.0)
        three = try! one ^ two
        XCTAssert(three == Rational(64.0))
        
        one = Rational(4.3)
        two = Rational(2.0)
        three = try! one ^ two
        XCTAssert(three == Rational(18.49))
        
        one = Rational(4.0)
        two = Rational(3.0)
        three = try! one ^ two
        XCTAssert(three == Rational(64.0))
        
        one = Rational(43.3)
        two = Rational(3.0)
        three = try! one ^ two
        XCTAssert(three == Rational(81182.737))
        
        one = Rational(43.3)
        three = one ^ 3
        XCTAssert(three == Rational(81182.737))
        
        one = Rational(123.415)
        two = Rational(4.0)
        three = try! one ^ two
        print(Double(three.numerator / three.denominator))
        XCTAssert(three.numerator == 371186158346739121 && three.denominator == 1600000000)
        
        // Исключения
        one = try! Rational(numeratorInt: 12, denominatorInt: 2)
        two = try! Rational(numeratorInt: 0, denominatorInt: 6)
        XCTAssertNil(try? one % two)
        
        one = try! Rational(numeratorInt: 12, denominatorInt: 2)
        two = try! Rational(numeratorInt: 0, denominatorInt: 6)
        XCTAssertNil(try? one / two)
        
        one = try! Rational(numeratorInt: 12, denominatorInt: 2)
        two = try! Rational(numeratorInt: 1, denominatorInt: 2)
        XCTAssertNil(try? one ^ two)
    }
    
    func testSqrt() throws {
        var one = try! Rational(numeratorInt: 16, denominatorInt: 9)
        XCTAssert((try! sqrt(rational: one)) == (try! Rational(numeratorInt: 4, denominatorInt: 3)))
        
        one = try! Rational(numeratorInt: 25, denominatorInt: 36)
        XCTAssert(try! sqrt(rational: one) == (try! Rational(numeratorInt: 5, denominatorInt: 6)))
        
        one = try! Rational(numeratorInt: 6234, denominatorInt: 24321)
        XCTAssert((try! sqrt(rational: one)).decimalView == 0.5062822308999314)
        
        one = try! Rational(numeratorInt: 3, denominatorInt: 13)
        print((try! sqrt(rational: one)).decimalView)
        XCTAssert((try! sqrt(rational: one)).decimalView == 0.48038446135362434)
    }
}
