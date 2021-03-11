//
//  ComputerV2.swift
//  ComputerV2
//
//  Created by Михаил Фокин on 04.03.2021.
//

import Foundation

class Computer {
    // varA =  ( 3 + 4 ) * 4 + 4 % 3 * ( varR + 3 )
    // varA =  (3+34)*45+4%355*(3+333)^23
    // (3+34)*45+4%355*(3+333)^23
    // (3+34)*45+4%355*(3+333)*23
    // (1+2)/(3+4*6.7)-5.3*4.4
    func run() {
        while true {
            print("> ", terminator: "")
            let line = readLine()?.lowercased()
            let lineWithoutSpace = line?.removeWhitespace() ?? ""
            if lineWithoutSpace.isEmpty { continue }
            if lineWithoutSpace == "exit" { exit(0) }
            if !checkErrors(line: lineWithoutSpace) { continue }
            _ = conversionPostfixForm(infixFomr: lineWithoutSpace)
            print(lineWithoutSpace)
        }
    }
    
    // MARK: Перевод строки в постфиксную форму.
    func conversionPostfixForm(infixFomr: String) -> String {
        let lineSpace = addSpace(line: infixFomr).split() { $0 == " "}.map{ String($0) }
        //print(addSpace(line: line))
        let prioritySign = ["(": 0, ")": 1, "+": 2, "-": 2, "*": 3, "/": 3, "%": 3, "^": 4]
        var postfixForm: String = String()
        var stack: String = String()
        for elem in lineSpace {
            if let priority = prioritySign[elem] {
                if priority == 1 {
                    while prioritySign[String(stack.last!)]! > 0 {
                        let char = stack.popLast()!
                        postfixForm += String(char) + " "
                    }
                    _ = stack.popLast()!
                }
                else if priority == 0 || stack.isEmpty || priority > prioritySign[String(stack.last!)]! {
                    stack += elem
                } else {
                    while priority <= prioritySign[String(stack.last!)]! {
                        let char = stack.popLast()!
                        postfixForm += String(char) + " "
                        if stack.isEmpty { break }
                    }
                    stack += elem
                }
            } else {
                postfixForm += elem + " "
            }
        }
        while !stack.isEmpty {
            let char = stack.popLast()!
            postfixForm += String(char) + " "
        }
        return String(postfixForm.dropLast())
    }
    
    // MARK: Вычисление значения из выражения в обратной польской нотоции.
    func calculateValue(postfixForm: String) throws -> Double {
        var stack = [String]()
        let elements = postfixForm.split() { $0 == " "}.map{ String($0) }
        for element in elements {
            if "*/^+-".contains(element) {
                guard let secondValue = stack.popLast(), let firstValue = stack.popLast() else {
                    throw Exception(massage: "Invalid operand.")
                }
                let first = Double(firstValue)!
                let second = Double(secondValue)!
                var temp = Double()
                switch element {
                case "+":
                    temp = first + second
                case "-":
                    temp = first - second
                case "*":
                    temp = first * second
                case "/":
                    if second == 0 {
                        throw Exception(massage: "Division by zero.")
                    }
                    temp = first / second
                //case "%":
                //    temp = first % second
                case "^":
                    temp = pow(first, second)
                default:
                    break
                }
                stack.append(String(temp))
            } else {
                stack.append(element)
            }
        }
        guard let last = stack.popLast(), let result = Double(last) else {
            throw Exception(massage: "Invalid operand.")
        }
        return result
    }
    
    // MARK: Добавляет пробелы слева и справа от +-*/%()^
    func addSpace(line: String) -> String {
        var string = String()
        for char in line {
            if "+-*/%()^".contains(char) {
                string += " \(char) "
            } else {
                string += String(char)
            }
        }
        return string
    }
    
    // MARK: Проверка входной строки на ошибки синтаксиса и правельности растановки скобок.
    private func checkErrors(line: String) -> Bool {
        let checker = Checker()
        do {
            try checker.checkCountSymbolEqual(line: line)
            let leftRieght = line.split(){ $0 == "=" }.map{ String($0) }
            for lr in leftRieght {
                try checker.checkLine(line: lr)
                try checker.checkBreckets(line: lr)
            }
        } catch let exception as Exception {
            systemError(massage: exception.massage)
            return false
        } catch {}
        return true
    }
    
    // MARK: Вывод сообщения об ошибке в поток ошибок.
    private func systemError(massage: String) {
        fputs(massage + "\n", stderr)
    }
}

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
