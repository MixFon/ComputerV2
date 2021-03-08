//
//  Imaginary.swift
//  ComputerV2
//
//  Created by Михаил Фокин on 08.03.2021.
//

import Foundation

class Imaginary {
    var im: Rational
    var re: Rational
    
    var value: String { return "\(im.numerator)/\(im.denominator)i \(re.numerator)/\(re.denominator)" }
    
    init() {
        self.im = Rational()
        self.re = Rational()
    }
    
    init(imaginary im: Rational, rational ra: Rational) {
        self.im = im
        self.re = ra
    }
    
    init(imaginary im: Int64, rational re: Int64) {
        self.im = Rational(im)
        self.re = Rational(re)
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

// MARK: Оператор сложения.
func + (left: Imaginary, right: Imaginary) -> Imaginary {
    return Imaginary(imaginary: left.im + right.im, rational: left.re + right.re)
}

// MARK: Оператор вычитания.
func - (left: Imaginary, right: Imaginary) -> Imaginary {
    return Imaginary(imaginary: left.im - right.im, rational: left.re - right.re)
}

// MARK: Оператор умножения.
func * (left: Imaginary, right: Imaginary) -> Imaginary {
    let imaginary = left.re * right.im + left.im * right.re
    let rational = left.re * right.re - left.im * right.im
    return Imaginary(imaginary: imaginary, rational: rational)
}

// MARK: Оператор деления.
func / (left: Imaginary, right: Imaginary) -> Imaginary {
    let squere = right.re * right.re + right.im * right.im
    let imaginary = try! (left.im * right.re - left.re * right.im) / squere
    let rational = try! (left.re * right.re + left.im * right.im ) / squere
    return Imaginary(imaginary: imaginary, rational: rational)
}

// MARK: Оператор возведения в степень.
infix operator ^
func ^ (imaginary: Imaginary, power: Int) throws -> Imaginary {
    var imaginatyValue = imaginary
    for _ in 1..<power {
        imaginatyValue = imaginatyValue * imaginary
    }
    return imaginatyValue
}

// MARK: Оператор эквивалентности.
func == (left: Imaginary, right: Imaginary) -> Bool {
    return left.im == right.im && left.re == right.re
}

// MARK: Оператор неэквивалентности.
func != (left: Imaginary, right: Imaginary) -> Bool {
    return !(left == right)
}
