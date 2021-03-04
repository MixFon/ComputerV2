//
//  Checker.swift
//  ComputerV2
//
//  Created by Михаил Фокин on 04.03.2021.
//

import Foundation

struct Exception: Error {
    var massage: String
}

class Checker {
    
    // MARK: Проверяет количество символов =
    func checkCountSymbolEqual(line: String) throws {
        if line.filter({ $0 == "=" }).count > 1 {
            throw Exception(massage: "The numbers of characters \'=\' must not exceed 1.")
        }
    }
    
    // MARK: Проверяем прально ли раставлены скобки
    func checkBreckets(line: String) throws {
        let error = "The brackets are placed incorrectly."
        var stack: String = ""
        for char in line {
            if char == "(" {
                stack.append(char)
            }
            else if char == ")" {
                if stack.isEmpty {
                    throw Exception(massage: error)
                } else {
                    _ = stack.popLast()
                }
            }
        }
        if !stack.isEmpty {
            throw Exception(massage: error)
        }
    }
    
    // MARK: Проверка синтаксиса строки
    public func checkLine(line: String) throws {
        let firstChar = line.first ?? "+"
        let lastChar = line.last ?? "+"
        if "^*/%.".contains(firstChar) {
            throw Exception(massage: "Invalid syntax in start string.")
        }
        if "^*/%.+-".contains(lastChar) {
            throw Exception(massage: "Invalid syntax in end string.")
        }
        for (i, c) in line.enumerated() {
            if c == "." {
                let charBefore = line[line.index(line.startIndex, offsetBy: i - 1)]
                let charAfter = line[line.index(line.startIndex, offsetBy: i + 1)]
                if !charBefore.isNumber || !charAfter.isNumber {
                    throw Exception(massage: "Error: \(charBefore)\(c)\(charAfter). Error in the determination of the coefficient.")
                }
            }
        }
    }
    
//    public func checkExtraneousCharacters(cheking: String, source: String) -> Bool {
//        for c in cheking {
//            if !source.contains(c) {
//                return false
//            }
//        }
//        return true
//    }
}
