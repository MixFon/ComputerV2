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
    
    // MARK: Проверяет количество символов = и ?
    func checkCountSymbolEqual(line: String) throws {
        if line.filter({ $0 == "=" }).count != 1 {
            throw Exception(massage: "Invalid syntax. Missing character \'=\'.")
        }
        if line.filter({ $0 == "?" }).count > 1 {
            throw Exception(massage: "Invalid syntax. The number of question marks not excceed 1.")
        }
    }
    
    // MARK: Проверяем прально ли раставлены скобки
    func checkBreckets(line: String) throws {
        let error = "The brackets are placed incorrectly."
        var stack = String()
        let dict = [")":"(", "}":"{", "]":"["]
        for c in line {
            if "({[".contains(c) {
                stack.append(c)
            } else if ")}]".contains(c) {
                if stack.isEmpty {
                    throw Exception(massage: error)
                }
                guard let value = dict[String(c)] else { throw Exception(massage: error) }
                guard let last = stack.popLast() else { throw Exception(massage: error) }
                if String(last) != value {
                    throw Exception(massage: error)
                }
            }
        }
        if !stack.isEmpty {
            throw Exception(massage: error)
        }
    }
    
    func checkLeftRightExpression(leftRigth: [String]) throws {
        try checkNameValue(left: leftRigth.first!)
        //try checkQuestionMark(right: leftRigth.last!)
    }
    
    // MARK: Проверка имени переменной.
    func checkNameValue(left: String) throws {
        if left == "i" {
            throw Exception(massage: "The variable name cannot be \"i\".")
        }
        if left.contains("?") {
            throw Exception(massage: "Invalid syntax question mark.")
        }
    }
    
    // MARK: Проверка знака вопроса в конце строки.
//    func checkQuestionMark(right: String) throws {
//        if right.contains("?") && right.count != 1 {
//            throw Exception(massage: "Invalid syntax question mark.")
//        }
//    }
    
    // MARK: Проверка синтаксиса строки
    public func checkLine(line: String) throws {
        let firstChar = line.first ?? "*"
        let lastChar = line.last ?? "*"
        if "^*/%.,]);".contains(firstChar) {
            throw Exception(massage: "Invalid syntax in start string.")
        }
        if "^*/%.,+-[(;".contains(lastChar) {
            throw Exception(massage: "Invalid syntax in end string.")
        }
        if line.contains(")(") || line.contains("][") || line.contains("()") || line.contains("[]"){
            throw Exception(massage: "Invalid syntax breckets.")
        }
        let lineWithoutDoubleAsterix = line.replace(string: "**", replacement: "@")
        for (i, c) in lineWithoutDoubleAsterix.enumerated() {
            if c == "." || c == "," {
                let charBefore = line[line.index(line.startIndex, offsetBy: i - 1)]
                let charAfter = line[line.index(line.startIndex, offsetBy: i + 1)]
                if !charBefore.isNumber || !charAfter.isNumber {
                    throw Exception(massage: "Error: \(charBefore)\(c)\(charAfter). Invalid syntax.")
                }
            } else if c == ";" {
                let charBefore = line[line.index(line.startIndex, offsetBy: i - 1)]
                let charAfter = line[line.index(line.startIndex, offsetBy: i + 1)]
                if charBefore != "]" || charAfter != "["{
                    throw Exception(massage: "Error: \(charBefore)\(c)\(charAfter). Invalid syntax matrix.")
                }
            } else if c == "[" && c != firstChar {
                let charBefore = line[line.index(line.startIndex, offsetBy: i - 1)]
                let charAfter = line[line.index(line.startIndex, offsetBy: i + 1)]
                if !"+-*;[(@".contains(charBefore) || !charAfter.isNumber && charAfter != "[" {
                    throw Exception(massage: "Error: \(charBefore)\(c)\(charAfter). Invalid syntax breckets.")
                }
            } else if c == "]" && c != lastChar {
                let charBefore = line[line.index(line.startIndex, offsetBy: i - 1)]
                let charAfter = line[line.index(line.startIndex, offsetBy: i + 1)]
                if !charBefore.isNumber && charBefore != "]" || !"+-*;])@".contains(charAfter){
                    throw Exception(massage: "Error: \(charBefore)\(c)\(charAfter). Invalid syntax breckets.")
                }
            } else if c == "(" && c != firstChar {
                let charBefore = line[line.index(line.startIndex, offsetBy: i - 1)]
                let charAfter = line[line.index(line.startIndex, offsetBy: i + 1)]
                if !"+-*/^%(@".contains(charBefore) || "+-*/^%@".contains(charAfter) {
                    throw Exception(massage: "Error: \(charBefore)\(c)\(charAfter). Invalid syntax breckets.")
                }
            } else if c == ")" && c != lastChar {
                let charBefore = line[line.index(line.startIndex, offsetBy: i - 1)]
                let charAfter = line[line.index(line.startIndex, offsetBy: i + 1)]
                if "+-*/^%(@".contains(charBefore) || !"+-*/^%)@".contains(charAfter){
                    throw Exception(massage: "Error: \(charBefore)\(c)\(charAfter). Invalid syntax breckets.")
                }
            }
            if "+-^*/%.,@".contains(c) {
                let charBefore = line[line.index(line.startIndex, offsetBy: i - 1)]
                let charAfter = line[line.index(line.startIndex, offsetBy: i + 1)]
                if "+-^*/%.,([@".contains(charBefore) || "+-^*/%.,)]@".contains(charAfter){
                    throw Exception(massage: "Error: \(charBefore)\(c)\(charAfter). Invalid syntax operators.")
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
