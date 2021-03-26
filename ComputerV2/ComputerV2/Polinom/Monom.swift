//
//  Monom.swift
//  ComputerV1
//
//  Created by Михаил Фокин on 24.02.2021.
//

import Foundation

class Monom: NSObject {
    var coefficient: Double
    var degree: Int
    
    init(coefficient: Double, degree: Int) {
        self.coefficient = coefficient
        self.degree = degree
    }
    
    init(monom: String) {
        coefficient = 0
        degree = 0
        super.init()
        var elements: [String]
        if monom.contains("*") {
            elements = monom.split() {$0 == "*"}.map{ String($0) }
        } else if monom.contains("X") {
            elements = monom.split() {$0 == "X"}.map{ String($0) }
        } else {
            coefficient = Double(monom) ?? 0.0
            degree = 0
            return
        }
        let count = elements.count
        switch count {
        case 0:
            coefficient = 1
            degree = 1
        case 1:
            try? self.oneCountElement(elem: elements[0])
        case 2:
            self.twoCountElement(elements: elements)
        default:
            break
        }
    }
    
    override var description: String { return "\(String(format: "%+1g", coefficient))" +
        String(degree == 0 ? "": degree == 1 ? "X": "X^\(self.degree)") }
    
    private func oneCountElement(elem: String) throws {
        guard let char = elem.first else { print("Error!!! Character."); return }
        degree = 1
        switch char {
        case "+":
            if elem.count == 1 {
                coefficient = 1
            } else {
                coefficient = Double(elem) ?? 0
            }
        case "-":
            if elem.count == 1 {
                coefficient = -1
            } else {
                coefficient = Double(elem) ?? 0
            }
        case "^":
            let digit = elem.dropFirst()
            coefficient = 1
            guard let degree = Int(digit) else {
                throw Exception(massage: "The degree in not an integer.")
            }
            self.degree = degree
        default:
            coefficient = Double(elem) ?? 0
        }
    }
    
    private func twoCountElement(elements: [String]) {
        let coeficient: String
        let degree: String
        if elements[0].contains("^"){
            coeficient = elements[1]
            degree = elements[0]
        } else {
            coeficient = elements[0]
            degree = elements[1]
        }
        workingCoeficient(coeficient: coeficient)
        workingDegree(degree: degree)
    }
    
    private func workingCoeficient(coeficient: String) {
        guard let char = coeficient.first else { print("Error!!! Character."); return }
        switch char {
        case "+":
            if coeficient.count == 1 {
                coefficient = 1.0
            } else {
                coefficient = Double(coeficient) ?? 0
            }
        case "-":
            if coeficient.count == 1 {
                coefficient = -1
            } else {
                coefficient = Double(coeficient) ?? 0
            }
        default:
            coefficient = Double(coeficient) ?? 0
        }
    }
    
    private func workingDegree(degree: String) {
        guard let char = degree.first else { print("Error!!! Character."); return }
        switch char {
        case "X":
            if degree.count > 1 {
                let index = degree.index(degree.startIndex, offsetBy: 2)
                self.degree = Int(degree[index...]) ?? 0
            } else {
                self.degree = 1
            }
        case "^":
            let index = degree.index(degree.startIndex, offsetBy: 1)
            self.degree = Int(degree[index...]) ?? 0
        default:
            break
        }
    }
}
