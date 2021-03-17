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
    switch left.type {
    case .rational:
        let rational = left as! Rational
        switch right.type {
        case .rational:
            let rationalRight = right as! Rational
            return rational + rationalRight
        case .imaginary:
            let imaginary = right as! Imaginary
            return imaginary + rational
        case .matrix:
            let matrix = right as! Matrix
            return matrix + rational
        default:
            break
        }
    case .imaginary:
        let imaginary = left as! Imaginary
        switch right.type {
        case .rational:
            let rational = right as! Rational
            return imaginary + rational
        case .imaginary:
            let imaginaryRight = right as! Imaginary
            return imaginary + imaginaryRight
        default:
            break
        }
    case .matrix:
        let matrix = left as! Matrix
        switch right.type {
        case .rational:
            let rational = right as! Rational
            return matrix + rational
        case .matrix:
            let matrixRight = right as! Matrix
            return try matrix + matrixRight
        default:
            break
        }
    default:
        break
    }
    return Rational()
}

func - (left: TypeProtocol, right: TypeProtocol) throws -> TypeProtocol {
    return try left + (-right)
}

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

func additing<T1: TypeProtocol, T2: TypeProtocol>(left: T1, right: T2) throws -> TypeProtocol {
    let one = left 
    let two = right 
    return try one + two
}
