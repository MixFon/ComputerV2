//
//  Rational.swift
//  ComputerV2
//
//  Created by Михаил Фокин on 07.03.2021.
//

import Foundation

class Rational {
    var numerator: Int64
    var denominator: Int64
    
    init() {
        self.numerator = 0
        self.denominator = 1
    }
    
    init(numerator: Int64, denominator: Int64) throws {
        if denominator == 0 {
            throw Exception(massage: "Division by zero. Denominator mast not be zero.")
        }
        self.numerator = 0
        self.denominator = 1
        self.reduceFraction(numerator: numerator, denominator: denominator)
    }
    
    // MARK: Конструктор копирования
    init(other: Rational) {
        self.numerator = other.numerator
        self.denominator = other.denominator
    }
    
    // MARK: Конструктор с рациональным аргкментом.
    convenience init(doubleValue x0: Double, withPrecision eps: Double = 1.0E-10) {
        var x = x0
        var a = x.rounded(.down)
        var (h1, k1, h, k) = (Int64(1), Int64(0), Int64(a), Int64(1))
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = x.rounded(.down)
            (h1, k1, h, k) = (h, k, h1 + Int64(a) * h, k1 + Int64(a) * k)
        }
        try! self.init(numerator: h, denominator: k)
    }
    
    // MARK: Конструктор с целым параметром.
    init(intValue: Int64) {
        self.numerator = intValue
        self.denominator = 1
    }
    
    // MARK: Сокращает дробь.
    private func reduceFraction(numerator: Int64, denominator: Int64) {
        let sign = Double(numerator / denominator)
        self.numerator = abs(numerator)
        self.denominator = abs(denominator)
        let nod = nodNunbers(one: self.numerator, two: self.denominator)
        self.numerator /= nod
        self.denominator /= nod
        if sign < 0 {
            self.numerator = -self.numerator
        }
    }
    
    // MARK: Определение наименьшего общего делителя.
    private func nodNunbers(one: Int64, two: Int64) -> Int64 {
        var a = one
        var b = two
        while (a != 0 && b != 0) {
            if (a > b) {
                a = a % b;
            } else {
                b = b % a;
            }
        }
        return (a + b);
    }
}

func + (left: Rational, right: Rational) -> Rational {
    let numerator = right.denominator * left.numerator + left.denominator * right.numerator
    let denominater = left.denominator * right.denominator
    return try! Rational(numerator: numerator, denominator: denominater)
}

func - (left: Rational, right: Rational) -> Rational {
    let numerator = right.denominator * left.numerator - left.denominator * right.numerator
    let denominater = left.denominator * right.denominator
    return try! Rational(numerator: numerator, denominator: denominater)
}

func * (left: Rational, right: Rational) -> Rational {
    let numerator = left.numerator * right.numerator
    let denominater = left.denominator * right.denominator
    return try! Rational(numerator: numerator, denominator: denominater)
}

func / (left: Rational, right: Rational) throws -> Rational {
    if right.numerator == 0 {
        throw Exception(massage: "Division by zero.")
    }
    let numerator = left.numerator * right.denominator
    let denominater = left.denominator * right.numerator
    return try! Rational(numerator: numerator, denominator: denominater)
}

func % (left: Rational, right: Rational) throws -> Rational {
    if right.numerator == 0 {
        throw Exception(massage: "Division by zero.")
    }
    let integer = try! left / right
    let temp = Double(integer.numerator / integer.denominator).rounded(.down)
    let rez = left - (try! Rational(numerator: Int64(temp) * right.numerator, denominator: right.denominator))
    return rez
}

infix operator ^
func ^ (rational: Rational, power: Rational) throws -> Rational {
    if power.denominator != 1 {
        throw Exception(massage: "The degree in not an integer.")
    }
    let numerator = pow(Decimal(rational.numerator), Int(power.numerator))
    let denominator = pow(Decimal(rational.denominator), Int(power.numerator))
    return try! Rational(numerator: NSDecimalNumber(decimal: numerator).int64Value,
                         denominator: NSDecimalNumber(decimal: denominator).int64Value)
}

func == (left: Rational, right: Rational) -> Bool {
    return left.numerator == right.numerator && left.denominator == right.denominator
}

func != (left: Rational, right: Rational) -> Bool {
    return !(left == right)
}

extension Decimal {
    var isWholeNumber: Bool {
        return self.isZero || (self.isNormal && self.exponent >= 0)
    }
}
