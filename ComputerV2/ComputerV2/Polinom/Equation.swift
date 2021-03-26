//
//  Computer.swift
//  ComputerV1
//
//  Created by Михаил Фокин on 28.02.2021.
//

import Foundation

class Equation {
    var polinom: Polinom?
    
    init(polindromString: String) {
        checkErrors(polingrom: polindromString)
        polinom = Polinom(polindrom: polindromString)
        solveEquation()
    }
    
    init(polinom: Polinom) {
        self.polinom = polinom
        solveEquation()
    }
    
    private func solveEquation() {
        guard let polindrom = self.polinom else { return }
        if polindrom.monoms.isEmpty {
            printOutput(massage: "Reduced form: 0=0")
            printOutput(massage: "Polynomial degree: 0")
            printOutput(massage: "Each real number is a solution.")
            return
        }
        printInfo()
        switch polindrom.getPolynominalDegree() {
        case 0:
            printOutput(massage: "The equation has no solution.")
            return
        case 1:
            solutionLinearEqaution()
        case 2:
            solvingQuadraticEquations()
        default:
            printOutput(massage: "The polynomial degree is strictly greater than 2, I can't solve.")
            break
        }
    }
    
    private func printOutput(massage: String) {
        print(massage)
    }
    
    private func systemError(massage: String) {
        fputs(massage + "\n", stderr)
        exit(-1)
    }
    
    private func solvingQuadraticEquations() {
        guard let polindrom = self.polinom else { return }
        if isZeroSolution() { return }
        let a: Double
        let b: Double
        let c: Double
        a = polindrom.monoms[0].coefficient
        if polindrom.monoms.count == 2 && polindrom.monoms[1].degree == 0 {
            b = 0
            c = polindrom.monoms[1].coefficient
        } else if polindrom.monoms.count == 2 && polindrom.monoms[1].degree == 1 {
            b = polindrom.monoms[1].coefficient
            c = 0
        } else {
            b = polindrom.monoms[1].coefficient
            c = polindrom.monoms[2].coefficient
        }
        let disctiminant = b * b - 4.0 * a * c
        if disctiminant < 0 {
            printOutput(massage: "Discriminant is strictly negative, the two imaginary solutions are:")
            outputImaginarySolution(a, b, myFabs(disctiminant))
            return
        } else if disctiminant == 0 {
            printOutput(massage: "The discriminant is zero, one solution:")
            outputLinearSolution(-b - mySqrt(disctiminant), 2 * a)
            return
        }
        printOutput(massage: "Discriminant is strictly positive, the two solutions are:")
        outputLinearSolution(-b - mySqrt(disctiminant), 2 * a)
        outputLinearSolution(-b + mySqrt(disctiminant), 2 * a)
    }
    
    private func outputImaginarySolution(_ a: Double, _ b: Double, _ d: Double) {
        printOutput(massage: String(format: "%g %+gi", b / (2.0 * a), mySqrt(d) / (2.0 * a)))
        printOutput(massage: String(format: "%g %+gi", b / (2.0 * a), (-1.0) * mySqrt(d) / (2.0 * a)))
    }
    
    
    private func mySqrt(_ source: Double) -> Double {
        var temp = Double(0)
        var sqrt = Double(0)
        sqrt = source / Double(2)
        while sqrt != temp {
            temp = sqrt
            sqrt = (source / temp + temp) / 2.0
        }
        return sqrt
    }
    
    private func myFabs(_ source: Double) -> Double {
        if source < 0 {
            return -source
        }
        return source
    }
    
    private func isZeroSolution() -> Bool {
        guard let polindrom = self.polinom else { return false }
        if polindrom.monoms.count == 1 {
            printOutput(massage: "The solution is:")
            printOutput(massage: "0")
            return true
        }
        return false
    }
    
    private func solutionLinearEqaution() {
        guard let polindrom = self.polinom else { return }
        if isZeroSolution() { return }
        let b = polindrom.monoms[1].coefficient
        let k = polindrom.monoms[0].coefficient
        printOutput(massage: "The solution is:")
        outputLinearSolution(-b, k)
    }
    
    private func outputLinearSolution(_ b: Double, _ k: Double) {
        if isIntegerNumber(number: b) && isIntegerNumber(number: k) {
            printRationalView(coefB: b, coefK: k)
        } else {
            printOutput(massage: String(format: "%g", b / k))
        }
    }
    
    private func printRationalView(coefB: Double, coefK: Double) {
        var b = coefB
        var k = coefK
        let sign = b / k
        b = myFabs(b)
        k = myFabs(k)
        let nod = nodNunbers(one: Int(b), two: Int(k))
        b = b / Double(nod)
        k = k / Double(nod)
        if sign < 0 {
            b = -b
        }
        if k == 1 {
            printOutput(massage: "\(Int(b))")
        } else {
            printOutput(massage: "\(Int(b))/\(Int(k)) (\(b / k))")
        }
    }
    
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
    
    private func isIntegerNumber(number: Double) -> Bool {
        guard let temp = Int(exactly: number) else {
            return false
        }
        return Double(temp) == number
    }
    
    private func gerArgumentCommandLine() -> String {
        let arguments = CommandLine.arguments[1...]
        if arguments.count > 1 {
            systemError(massage: "Too many argusents.\nUsed: ./computer \"polinom\"")
        }
        let polindromString = arguments.joined().uppercased()
        if polindromString.isEmpty {
            systemError(massage: "Empty argument.\nUsed: ./computer \"polinom\"")
        }
        return polindromString
    }
    
    private func printInfo() {
        guard let polindrom = self.polinom else { return }
        printOutput(massage: "Reduced form: \(polindrom.getReducedForm())=0")
        printOutput(massage: "Polynomial degree: \(polindrom.getPolynominalDegree())")
    }
    
    private func checkErrors(polingrom: String) {
        do {
            try checkPolindrom(polindrom: polingrom)
        } catch let exception as Exception {
            systemError(massage: exception.massage)
        } catch {}
    }

    private func checkPolindrom(polindrom: String) throws {
        let polindrom = polindrom.uppercased().removeWhitespace()
        let firstChar = polindrom.first
        let lastChar = polindrom.last
        if firstChar == "*" || firstChar == "^" || firstChar == "." {
            throw Exception(massage: "Invalid syntax in start string.")
        }
        if lastChar == "+" || lastChar == "-" || lastChar == "*" || lastChar == "^" || lastChar == "." {
            throw Exception(massage: "Invalid syntax in end string.")
        }
        if polindrom.filter({ $0 == "=" }).count > 1 {
            throw Exception(massage: "The numbers of characters \'=\' must not exceed 1.")
        }
        if !checkExtraneousCharacters(cheking: polindrom, source: " +-*^X=1234567890.") {
            throw Exception(massage: "Invalid character.")
        }
        for (i, c) in polindrom.enumerated() {
            if c == "^" {
                let charBefore = polindrom[polindrom.index(polindrom.startIndex, offsetBy: i - 1)]
                let charAfter = polindrom[polindrom.index(polindrom.startIndex, offsetBy: i + 1)]
                if charBefore != "X" || !checkExtraneousCharacters(cheking: String(charAfter), source: "1234567890") {
                    throw Exception(massage: "Error: \(charBefore)\(c)\(charAfter). The monomial degree is specified incorrectly.")
                }
            } else if c == "*" {
                let charBefore = polindrom[polindrom.index(polindrom.startIndex, offsetBy: i - 1)]
                let charAfter = polindrom[polindrom.index(polindrom.startIndex, offsetBy: i + 1)]
                if !checkExtraneousCharacters(cheking: String(charBefore), source: "1234567890") || charAfter != "X" {
                    throw Exception(massage: "Error: \(charBefore)\(c)\(charAfter). Error in the determination of the coefficient.")
                }
            } else if c == "." {
                let charBefore = polindrom[polindrom.index(polindrom.startIndex, offsetBy: i - 1)]
                let charAfter = polindrom[polindrom.index(polindrom.startIndex, offsetBy: i + 1)]
                if !checkExtraneousCharacters(cheking: String(charBefore), source: "1234567890") ||
                    !checkExtraneousCharacters(cheking: String(charAfter), source: "1234567890") {
                    throw Exception(massage: "Error: \(charBefore)\(c)\(charAfter). Error in the determination of the coefficient.")
                }
            }
        }
        if !checkMultyX(polindrom: polindrom) {
            throw Exception(massage: "Invalid syntax monom.")
        }
    }
    
    private func checkMultyX(polindrom: String) -> Bool {
        let polinomsLiftRight = Polinom.getLeftRightPolinoms(polindrom: polindrom)
        let monoms = polinomsLiftRight.0 + polinomsLiftRight.1
        for monom in monoms {
            if monom.count == 1 {
                if "+-".contains(monom) {
                    return false
                }
            }
            if monom.filter({ $0 == "X" }).count > 1 {
                return false
            }
            if monom.filter({ $0 == "*" }).count > 1 {
                return false
            }
            if monom.filter({ $0 == "." }).count > 1 {
                return false
            }
            if monom.last != "X" {
                for (i ,c) in monom.enumerated() {
                    if c == "X" {
                        let charAfter = monom[monom.index(monom.startIndex, offsetBy: i + 1)]
                        if charAfter != "^" {
                            return false
                        }
                    }
                }
            }
            if monom.contains("^") {
                let splitDegree = monom.split() { $0 == "^" }.map{String($0)}
                guard Int(splitDegree[1]) != nil else {
                    return false
                }
            }
        }
        return true
    }

    private func checkExtraneousCharacters(cheking: String, source: String) -> Bool {
        for c in cheking {
            if !source.contains(c) {
                return false
            }
        }
        return true
    }
}
