//
//  Rational.swift
//  ComputerV2
//
//  Created by Михаил Фокин on 07.03.2021.
//

import Foundation

class Rational: NSObject, TypeProtocol {
    var rational: Double
    
    override init() {
        self.rational = 0
    }
    
    override var description: String {return "\(rational)"}
    
    // MARK: Конструктор создания нового значения из строки
    required init(expression: String) throws {
        if expression.isEmpty {
            self.rational = 1
            return
        }
        guard let value = Double(expression) else {
            throw Exception(massage: "Error create rational value.")
        }
        self.rational = value
    }
    
    // MARK: Конструктор копирования
    init(other: Rational) {
        self.rational = other.rational
    }
    
    // MARK: Конструктор с целым параметром.
    init(_ rational: Double) {
        self.rational = rational
    }
    
    // MARK: Возвращает число в виде дроби с числителем и знаменателем
     func getNumeratorDenuminator(_ doubleValue: Double, withPrecision eps: Double = 1.0E-10) -> (Int, Int) {
        var x = doubleValue
        var a = x.rounded(.down)
        var (h1, k1, h, k) = (1, 0, Int(a), 1)
        while x - a > eps * Double(k) * Double(k) {
            x = 1.0/(x - a)
            a = x.rounded(.down)
            (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
        }
        (h, k) = reduceFraction(numerator: h, denominator: k)
        return (h, k)
    }
    
    // MARK: Сокращает дробь.
    private func reduceFraction(numerator: Int, denominator: Int) -> (Int, Int) {
        let sign = Double(numerator) / Double(denominator)
        var num = abs(numerator)
        var den = abs(denominator)
        let nod = nodNunbers(one: numerator, two: denominator)
        num /= nod
        den /= nod
        if sign < 0 {
            num = -num
        }
        return (num, den)
    }
    
    // MARK: Определение наименьшего общего делителя.
    private func nodNunbers(one: Int, two: Int) -> Int {
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

func % (left: Rational, right: Rational) throws -> Rational {
    if right.rational == 0 {
        throw Exception(massage: "Division by zero.")
    }
    return Rational(left.rational.truncatingRemainder(dividingBy: right.rational))
}

extension Rational {
    static func + (left: Rational, right: Rational) -> Rational {
        return Rational(left.rational + right.rational)
    }

    static func - (left: Rational, right: Rational) -> Rational {
        return Rational(left.rational - right.rational)
    }

    static func * (left: Rational, right: Rational) -> Rational {
        return Rational(left.rational * right.rational)
    }

    static func / (left: Rational, right: Rational) throws -> Rational {
        if right.rational == 0 {
            throw Exception(massage: "Division by zero.")
        }
        return Rational(left.rational / right.rational)
    }
    
    static func ^ (number: Rational, power: Rational) -> Rational {
        return Rational(pow(number.rational, power.rational))
    }

    static func ^ (number: Rational, power: Double) -> Rational {
        return Rational(pow(number.rational, power))
    }

    static func == (left: Rational, right: Rational) -> Bool {
        return left.rational == right.rational
    }

    static func != (left: Rational, right: Rational) -> Bool {
        return !(left == right)
    }

    
}

func sqrt(rational: Rational) -> Rational {
    return Rational(sqrt(rational.rational))
}
