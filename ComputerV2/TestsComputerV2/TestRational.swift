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
        var two = try! Rational(numerator: 12, denominator: 24)
        XCTAssert(two.numerator == 1 && two.denominator == 2)
        
        two = try! Rational(numerator: 3, denominator: 7)
        XCTAssert(two.numerator == 3 && two.denominator == 7)
        
        two = try! Rational(numerator: 6, denominator: 2)
        XCTAssert(two.numerator == 3 && two.denominator == 1)
        
        two = try! Rational(numerator: 1, denominator: 7)
        XCTAssert(two.numerator == 1 && two.denominator == 7)
        
        two = try! Rational(numerator: 3, denominator: 7)
        XCTAssert(two.numerator == 3 && two.denominator == 7)
        
        var three = try? Rational(numerator: 4, denominator: 0)
        XCTAssertNil(three)
        
        // Коструктор копирования
        three = Rational(other: two)
        XCTAssert(three!.numerator == 3 && three!.denominator == 7)
        
        // Конструктор с десятичным аргументом
        var four = Rational(doubleValue: 0.5)
        XCTAssert(four.numerator == 1 && four.denominator == 2)
        
        four = Rational(doubleValue: 1.7)
        XCTAssert(four.numerator == 17 && four.denominator == 10)
        
        four = Rational(doubleValue: 0.007)
        XCTAssert(four.numerator == 7 && four.denominator == 1000)
        
        four = Rational(doubleValue: 0.7)
        XCTAssert(four.numerator == 7 && four.denominator == 10)
        
        four = Rational(doubleValue: 0.333)
        XCTAssert(four.numerator == 333 && four.denominator == 1000)
        
        four = Rational(doubleValue: 2.25)
        XCTAssert(four.numerator == 9 && four.denominator == 4)
        
        four = Rational(doubleValue: 1.5)
        XCTAssert(four.numerator == 3 && four.denominator == 2)
    }
    
    func testOperators() throws {
        // Оператор +
        var one = try! Rational(numerator: 4, denominator: 7)
        var two = try! Rational(numerator: 5, denominator: 9)
        var three = one + two
        XCTAssert(three.numerator == 71 && three.denominator == 63)
        
        one = try! Rational(numerator: 14, denominator: 13)
        two = try! Rational(numerator: 2, denominator: 3)
        three = one + two
        XCTAssert(three.numerator == 68 && three.denominator == 39)
        
        one = try! Rational(numerator: 4, denominator: 6)
        two = try! Rational(numerator: 14, denominator: 4)
        three = one + two
        XCTAssert(three.numerator == 25 && three.denominator == 6)
        
        // Оператор -
        one = try! Rational(numerator: 15, denominator: 6)
        two = try! Rational(numerator: 5, denominator: 15)
        three = one - two
        XCTAssert(three.numerator == 13 && three.denominator == 6)
        
        one = try! Rational(numerator: 134, denominator: 123)
        two = try! Rational(numerator: 15, denominator: 85)
        three = one - two
        XCTAssert(three.numerator == 1909 && three.denominator == 2091)
        
        one = try! Rational(numerator: 12, denominator: 2)
        two = try! Rational(numerator: 18, denominator: 6)
        three = one - two
        XCTAssert(three.numerator == 3 && three.denominator == 1)
        
        // Оператор *
        one = try! Rational(numerator: 15, denominator: 6)
        two = try! Rational(numerator: 5, denominator: 15)
        three = one * two
        XCTAssert(three.numerator == 5 && three.denominator == 6)
        
        one = try! Rational(numerator: 134, denominator: 123)
        two = try! Rational(numerator: 15, denominator: 85)
        three = one * two
        XCTAssert(three.numerator == 134 && three.denominator == 697)
        
        one = try! Rational(numerator: 12, denominator: 2)
        two = try! Rational(numerator: 18, denominator: 6)
        three = one * two
        XCTAssert(three.numerator == 18 && three.denominator == 1)
        
        // Оператор /
        one = try! Rational(numerator: 15, denominator: 6)
        two = try! Rational(numerator: 5, denominator: 15)
        three = try! one / two
        XCTAssert(three.numerator == 15 && three.denominator == 2)
        
        one = try! Rational(numerator: 134, denominator: 123)
        two = try! Rational(numerator: 15, denominator: 85)
        three = try! one / two
        XCTAssert(three.numerator == 2278 && three.denominator == 369)
        
        one = try! Rational(numerator: 12, denominator: 2)
        two = try! Rational(numerator: 18, denominator: 6)
        three = try! one / two
        XCTAssert(three.numerator == 2 && three.denominator == 1)
        
        // Оператор %
        one = Rational(doubleValue: 7.9)
        two = Rational(doubleValue: 2.1)
        three = try! one % two
        XCTAssert(three == Rational(doubleValue: 1.6))
        
        one = Rational(doubleValue: 4.0)
        two = Rational(doubleValue: 3.0)
        three = try! one % two
        XCTAssert(three == Rational(doubleValue: 1.0))
        
        one = Rational(doubleValue: 4.0)
        two = Rational(doubleValue: 2.0)
        three = try! one % two
        XCTAssert(three == Rational(doubleValue: 0.0))
        
        // Исключения
        one = try! Rational(numerator: 12, denominator: 2)
        two = try! Rational(numerator: 0, denominator: 6)
        XCTAssertNil(try? one % two)
        
        one = try! Rational(numerator: 12, denominator: 2)
        two = try! Rational(numerator: 0, denominator: 6)
        XCTAssertNil(try? one / two)
        
        // Оператор ^
        one = Rational(doubleValue: 4.0)
        two = Rational(doubleValue: 3.0)
        three = try! one ^ two
        XCTAssert(three == Rational(doubleValue: 64.0))
        
        one = Rational(doubleValue: 4.3)
        two = Rational(doubleValue: 2.0)
        three = try! one ^ two
        XCTAssert(three == Rational(doubleValue: 18.49))
        
        one = Rational(doubleValue: 4.0)
        two = Rational(doubleValue: 3.0)
        three = try! one ^ two
        XCTAssert(three == Rational(doubleValue: 64.0))
        
        one = Rational(doubleValue: 43.3)
        two = Rational(doubleValue: 3.0)
        three = try! one ^ two
        XCTAssert(three == Rational(doubleValue: 81182.737))
        
        one = Rational(doubleValue: 123.415)
        two = Rational(doubleValue: 4.0)
        three = try! one ^ two
        print(Double(three.numerator / three.denominator))
        XCTAssert(three.numerator == 371186158346739121 && three.denominator == 1600000000)
    }

}
