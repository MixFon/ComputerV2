//
//  ComputerV2.swift
//  ComputerV2
//
//  Created by Михаил Фокин on 04.03.2021.
//

import Foundation

class Computer {
    
    var variables: [Variable]
    
    init() {
        variables = [Variable]()
    }
    
    func run() {
        while true {
            print("> ", terminator: "")
            guard var line = readLine() else { print(); break }
            line = line.lowercased()
            var lineWithoutSpace = line.replace(string: "**", replacement: "@")
            lineWithoutSpace = lineWithoutSpace.removeWhitespace()
            if lineWithoutSpace.isEmpty { continue }
            if lineWithoutSpace == "exit" { exit(0) }
            if !checkErrors(line: lineWithoutSpace) { continue }
            if !workingLine(line: lineWithoutSpace) { continue }
            //_ = conversionPostfixForm(infixFomr: lineWithoutSpace)
            //print(lineWithoutSpace)
        }
    }
    
    // MARK: Распредение на вывод значения или создания новой переменной.
    private func workingLine(line: String) -> Bool {
        do {
            if line.contains("?") {
                
            } else {
                try addVariable(line: line)
            }
        } catch let exception as Exception {
            systemError(massage: exception.massage)
            return false
        } catch {}
        return true
    }
    
    // MARK: Создание новой переменной и добавления в список переменных.
    private func addVariable(line: String) throws {
        let leftRight = line.split() { $0 == "=" }.map { String($0) }
        let nameVariable = leftRight.first!
        try checkValidName(name: nameVariable)
        // Создавать после вычисления значения переменной.
        let newVariable = Variable(name: nameVariable)
        let postfixForm = conversionPostfixForm(infixFomr: leftRight.last!)
        newVariable.value = try calculateValue(postfixForm: postfixForm)
        self.variables.append(newVariable)
        print(newVariable.value!.valueType)
        //let temp = newVariable.value as! Rational
        //print(temp.rational)
        //a = [[23,23]]
        
    }
    
    // MARK: Проверка имени переменной и функции. Имя не должно содержать цифр.
    private func checkValidName(name: String) throws {
        for c in name {
            if c.isNumber {
                throw Exception(massage: "The name of a variable or function must not contain numbers.")
            }
        }
    }
    
    // MARK: Перевод строки в постфиксную форму.
    func conversionPostfixForm(infixFomr: String) -> String {
        var lineSpace = infixFomr.addSpace().getWords()
        if "+-".contains(infixFomr.first!) {
            lineSpace = ["0"] + lineSpace
        }
        //print(addSpace(line: line))
        let prioritySign = ["(": 0, ")": 1, "+": 2, "-": 2, "*": 3, "@": 3, "/": 3, "%": 3, "^": 4]
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
    
    // MARK: Выполнение арифметических операций и возаращение результата операции.
    private func workingOperatorts(element: String, first: TypeProtocol, second: TypeProtocol) throws -> TypeProtocol {
        if first.type == .imaginary && second.type == .matrix ||
            first.type == .matrix && second.type == .imaginary {
            throw Exception(massage: "Error. The matrix and complex number types are incompatible.")
        }
        //let first = first as! Rational
        //let second = second as! Rational
        //let first = Double(firstValue)!
        //let second = Double(secondValue)!
        //var temp = TypeProtocol(expression: "[[3]]")
        var temp: TypeProtocol
        temp = Rational()
        switch element {
        case "+":
            return try first + second
        case "-":
            return try first - second
        case "*":
            return try first * second
        case "/":
            return try first / second
        case "%":
            return try first % second
        //case "^":
        //    temp = pow(first, second)
        case "@":
            return try first ** second
        default:
            break
        }
        return temp
    }
    
    // MARK: Вычисление значения из выражения в обратной польской нотоции.
    func calculateValue(postfixForm: String) throws -> TypeProtocol {
        var stack = [TypeProtocol]()
        let elements = postfixForm.split() { $0 == " "}.map{ String($0) }
        for element in elements {
            if "*/^+-%@".contains(element) {
                guard let secondValue = stack.popLast(), let firstValue = stack.popLast() else {
                    throw Exception(massage: "Invalid operand.")
                }
                let resultOperation = try workingOperatorts(element: element, first: firstValue, second: secondValue)
                stack.append(resultOperation)
            } else {
                let newValue = try createElementTypeProtocol(variable: element)
                stack.append(newValue)
            }
        }
        guard let last = stack.popLast() else {
            throw Exception(massage: "Invalid operand.")
        }
        return last
    }
    
    // MARK: Создание нового элемента типа TypeProtocol для добавления в стек.
    private func createElementTypeProtocol(variable: String) throws -> TypeProtocol {
        let type = getTypeVariable(variable: variable)
        switch type {
        case .rational:
            return try Rational(expression: variable)
        case .imaginary:
            return try Imaginary(expression: variable)
        case .matrix:
            return try Matrix(expression: variable)
        case .variable:
            for existingVariable in self.variables {
                if existingVariable.name == variable {
                    guard let value =  existingVariable.value else {
                        throw Exception(massage: "Invalig existing value.")
                    }
                    return value
                }
            }
        default:
            throw Exception(massage: "Invalid value: \(variable)")
        }
        return Rational()
    }
    
    // MARK: Определить тип: рациональное число, комплекское, матрица, существующая переменая, ошибка.
    private func getTypeVariable(variable: String) -> TypeVariable {
        if isRational(variable: variable) {
            return .rational
        }
        if isImaginary(variable: variable) {
            return .imaginary
        }
        if isMatrix(variable: variable) {
            return .matrix
        }
        if isExistingVariable(variable: variable) {
            return .variable
        }
        return .error
    }
    
    // MARK: Определяет, является ли строка рациональным числом.
    private func isRational(variable: String) -> Bool {
        if variable.isEmpty {
            return false
        }
        for c in variable {
            if !c.isNumber && c != "." {
                return false
            }
        }
        return true
    }
    
    // MARK: Определяет, является ли строка комплексным числом.
    private func isImaginary(variable: String) -> Bool {
        var variable = variable
        if variable.last != "i" {
            return false
        }
        if variable == "i" {
            return true
        }
        variable.remove(at: variable.index(before: variable.endIndex))
        return isRational(variable: variable)
    }
    
    // MARK: Определяет, является ли строка матрицей.
    private func isMatrix(variable: String) -> Bool {
        return variable.first == "[" && variable.last == "]"
    }
    
    // MARK: Определяет, является ли строка существующей переменной.
    private func isExistingVariable(variable: String) -> Bool {
        for existingVariable in self.variables {
            if existingVariable.name == variable {
                return true
            }
        }
        return false
    }
    
    // MARK: Проверка входной строки на ошибки синтаксиса и правельности растановки скобок.
    private func checkErrors(line: String) -> Bool {
        let checker = Checker()
        do {
            try checker.checkCountSymbolEqual(line: line)
            let leftRight = line.split(){ $0 == "=" }.map{ String($0) }
            try checker.checkLeftRightExpression(leftRigth: leftRight)
            for lr in leftRight {
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
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    // MARK: Добавляет пробелы слева и справа от +-*/%()^@
    func addSpace() -> String {
        let line = self
        var string = String()
        var coutnBreckets = 0
        for char in line {
            if char == "[" {
                coutnBreckets += 1
            } else if char == "]" {
                coutnBreckets -= 1
            }
            if "+-*/%()^@".contains(char) && coutnBreckets == 0 {
                string += " \(char) "
            } else {
                string += String(char)
            }
        }
        return string
    }
    
    // MARK: Разделяет строку на слова по пробелам и возвращает массив слов
    func getWords() -> [String] {
        return self.split() { $0 == " " }.map{ String($0) }
    }
}
