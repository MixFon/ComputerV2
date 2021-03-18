//
//  TypeProtocol.swift
//  ComputerV2
//
//  Created by Михаил Фокин on 15.03.2021.
//

import Foundation

protocol TypeProtocol {
    init(expression: String) throws
    var valueType: String { get }
}

extension TypeProtocol {
    
    //MARK: Определение типа переменной: rational, imaginaty, matrix.
    var type: TypeVariable {
        if self is Rational {
            return .rational
        }
        if self is Imaginary {
            return .imaginary
        }
        if self is Matrix {
            return .matrix
        }
        return .error
    }
}

// MARK: Оператор сложения классов протокола
func + (left: TypeProtocol, right: TypeProtocol) throws -> TypeProtocol {
    if let rational = left as? Rational {
        if let rationalRight = right as? Rational {
            return rational + rationalRight
        }
        if let imaginary = right as? Imaginary {
            return imaginary + rational
        }
        if let matrix = right as? Matrix {
            return matrix + rational
        }
    }
    if let imaginary = left as? Imaginary {
        if let rational = right as? Rational {
            return imaginary + rational
        }
        if let imaginaryRight = right as? Imaginary {
            return imaginary + imaginaryRight
        }
    }
    if let matrix = left as? Matrix {
        if let rational = right as? Rational {
            return matrix + rational
        }
        if let matrixRight = right as? Matrix {
            return try matrix + matrixRight
        }
    }
    return Rational()
}

// MARK: Оперетор вычитания классов протокола
func - (left: TypeProtocol, right: TypeProtocol) throws -> TypeProtocol {
    return try left + (-right)
}

// MARK: Префексный оператор перемены знака.
prefix func - (variable: TypeProtocol) -> TypeProtocol {
    switch variable.type {
    case .rational:
        let rational = variable as! Rational
        return -rational
    case .imaginary:
        let imaginary = variable as! Imaginary
        return -imaginary
    case .matrix:
        let matrix = variable as! Matrix
        return -matrix
    default:
        return Rational(0)
    }
}

// MARK: Оператор умножения классов протокола.
func * (left: TypeProtocol, right: TypeProtocol) throws -> TypeProtocol {
    if let rational = left as? Rational {
        if let rationalRight = right as? Rational {
            return rational * rationalRight
        }
        if let imaginary = right as? Imaginary {
            return imaginary * rational
        }
        if let  matrix = right as? Matrix {
            return matrix * rational
        }
    }
    if let imaginary = left as? Imaginary {
        if let rational = right as? Rational {
            return imaginary * rational
        }
        if let imaginatyRight = right as? Imaginary {
            return imaginary * imaginatyRight
        }
    }
    if let matrix = left as? Matrix {
        if let rational = right as? Rational {
            return matrix * rational
        }
        if let matrixRight = right as? Matrix {
            return try matrix * matrixRight
        }
    }
    return Rational()
}

// MARK: Оператор деления классов протоколов
func / (left: TypeProtocol, right: TypeProtocol) throws -> TypeProtocol {
    if let rational = left as? Rational {
        if let rationalRight = right as? Rational{
            return try rational / rationalRight
        }
        if let imaginary = right as? Imaginary {
            return try Imaginary(imaginary: Rational(), rational: rational) / imaginary
        }
        if let matrix = right as? Matrix {
            return try rational / matrix
        }
    }
    if let imaginary = left as? Imaginary {
        if let rational = right as? Rational {
            return try imaginary / Imaginary(imaginary: Rational(), rational: rational)
        }
        if let imaginaryRight = right as? Imaginary {
            return try imaginary / imaginaryRight
        }
    }
    if let matrix = left as? Matrix {
        if let rational = right as? Rational {
            return try matrix / rational
        }
        if let matrixRight = right as? Matrix {
            return try matrix / matrixRight
        }
    }
    return Rational()
}

func additing<T1: TypeProtocol, T2: TypeProtocol>(left: T1, right: T2) throws -> TypeProtocol {
    let one = left 
    let two = right 
    return try one + two
}
