//
//  Imaginary.swift
//  ComputerV2
//
//  Created by Михаил Фокин on 08.03.2021.
//

import Foundation

class Imaginary: TypeProtocol {
    
    var im: Rational
    var re: Rational
    
    var valueType: String { return "\(re) \(im)i" }
    
    init() {
        self.im = Rational()
        self.re = Rational()
    }
    
    // MARK: Конструктор создания комплексного числа из строки
    required convenience init(expression: String) throws {
        var expression = expression
        self.init()
        if expression == "i" {
            self.im = Rational(1.0)
            return
        }
        if expression.last == "i" {
            expression.remove(at: expression.index(before: expression.endIndex))
            self.im = try Rational(expression: expression)
        }
    }
    
    init(imaginary im: Rational, rational ra: Rational) {
        self.im = im
        self.re = ra
    }
    
    init(imaginary im: Double, rational re: Double) {
        self.im = Rational(im)
        self.re = Rational(re)
    }
    
    init(other: Imaginary) {
        self.im = other.im
        self.re = other.re
    }
}

extension Imaginary {
    // MARK: Оператор сложения.
    static func + (left: Imaginary, right: Imaginary) -> Imaginary {
        return Imaginary(imaginary: left.im + right.im, rational: left.re + right.re)
    }
    
    static func + (left: Imaginary, right: Rational) -> Imaginary {
        return Imaginary(imaginary: left.im, rational: left.re + right)
    }

    // MARK: Оператор вычитания.
    static func - (left: Imaginary, right: Imaginary) -> Imaginary {
        return Imaginary(imaginary: left.im - right.im, rational: left.re - right.re)
    }
    
    static prefix func - (imaginary: Imaginary) -> Imaginary {
        return Imaginary(imaginary: -imaginary.im , rational: -imaginary.re)
    }

    // MARK: Оператор умножения.
    static func * (left: Imaginary, right: Imaginary) -> Imaginary {
        let imaginary = left.re * right.im + left.im * right.re
        let rational = left.re * right.re - left.im * right.im
        return Imaginary(imaginary: imaginary, rational: rational)
    }

    // MARK: Оператор деления.
    static func / (left: Imaginary, right: Imaginary) -> Imaginary {
        let squere = right.re * right.re + right.im * right.im
        let imaginary = try! (left.im * right.re - left.re * right.im) / squere
        let rational = try! (left.re * right.re + left.im * right.im ) / squere
        return Imaginary(imaginary: imaginary, rational: rational)
    }

    // MARK: Оператор возведения в степень итеративно.
    static func ^ (imaginary: Imaginary, power: Int) -> Imaginary {
        var imaginatyValue = imaginary
        for _ in 1..<power {
            imaginatyValue = imaginatyValue * imaginary
        }
        return imaginatyValue
    }

    // MARK: Оператор возведения в степень по формуле Муавра.
    //infix operator ^
    //func ^ (imaginary: Imaginary, power: Int) throws -> Imaginary {
    //    let modul = sqrt(rational: (imaginary.im ^ 2) + (imaginary.re ^ 2))
    //    let arg = atan((try! imaginary.im / imaginary.re).rational)
    //    let re = (modul ^ Double(power)).rational * cos(Double(power) * arg)
    //    let im = (modul ^ Double(power)).rational * sin(Double(power) * arg)
    //    return Imaginary(imaginary: im, rational: re)
    //}


    // MARK: Оператор эквивалентности.
    static func == (left: Imaginary, right: Imaginary) -> Bool {
        return left.im == right.im && left.re == right.re
    }

    // MARK: Оператор неэквивалентности.
    static func != (left: Imaginary, right: Imaginary) -> Bool {
        return !(left == right)
    }

}

