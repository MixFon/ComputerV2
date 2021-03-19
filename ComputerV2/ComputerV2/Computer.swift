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
    
    // MARK: Создание или обновление переменной и добавления в список переменных.
    private func addVariable(line: String) throws {
        let leftRight = line.split() { $0 == "=" }.map { String($0) }
        let nameVariable = leftRight.first!
        try checkValidName(name: nameVariable)
        let newVariable = Variable(name: nameVariable)
        let postfixForm = conversionPostfixForm(infixFomr: leftRight.last!)
        newVariable.value = try calculateValue(postfixForm: postfixForm)
        updateVariables(newVariable: newVariable)
        print(newVariable.value!.valueType)
        //let temp = newVariable.value as! Rational
        //print(temp.rational)
        //a = [[23,23]]
        
    }
    
    // MARK: Проверка имени переменной и функции. Имя не должно содержать цифр и операторов. И должны быть одни ()
    private func checkValidName(name: String) throws {
        if name.filter({$0 == "("}).count > 1 {
            throw Exception(massage: "Invalid name function.")
        }
        for c in name {
            if c.isNumber {
                throw Exception(massage: "The name of a variable or function must not contain numbers.")
            }
            if "-+/*^@.%[".contains(c) {
                throw Exception(massage: "The name of a variable contains an invalid character: \(c)")
            }
        }
    }
    
    // MARK: Если переменная уже была создана - заменяем на новую, нет - добавляем новую.
    private func updateVariables(newVariable: Variable) {
        for (i, variable) in self.variables.enumerated() {
            if variable.name == newVariable.name {
                self.variables.remove(at: i)
                break
            }
        }
        self.variables.append(newVariable)
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
        case "^":
            return try first ^ second
        case "@":
            return try first ** second
        default:
            break
        }
        return Rational(Double.nan)
    }
    
    // MARK: Вычисление значения из выражения в обратной польской нотоции.
    func calculateValue(postfixForm: String) throws -> TypeProtocol {
        var stack = [TypeProtocol]()
        let elements = postfixForm.split() { $0 == " "}.map{ String($0) }
        print(elements)
        for element in elements {
            if "*/^+-%@".contains(element) {
                guard let secondValue = stack.popLast(), let firstValue = stack.popLast() else {
                    throw Exception(massage: "Invalid operand: \(element)")
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
        case .function:
            let nameFunction: String
            let argumentFunctions: String
            (nameFunction, argumentFunctions) = try splitNameArgumenrFunction(function: variable)
            // Получить значение аргумента. Оно должно быть Rationlan
            // Подставить полученное значение вместо переменной в функции. Вычислить его.
            // Результат вычисления тоже должен быть Rational
        default:
            throw Exception(massage: "Invalid value: \(variable)")
        }
        return Rational()
    }
    
    func splitNameArgumenrFunction(function: String) throws -> (String, String) {
        var function = function
        function.remove(at: function.index(before: function.endIndex))
        guard let indexBrecket = function.firstIndex(of: "(") else {
            throw Exception(massage: "Error in splitting the function name and argument.")
        }
        let indexBefore = function.index(before: indexBrecket)
        let indexAfter = function.index(after: indexBrecket)
        let name = function[...indexBefore]
        let argument = function[indexAfter...]
        return (String(name), String(argument))
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
            if variable.contains("(") {
                return .function
            } else {
                return .variable
            }
        }
        return .error
    }
    
    // MARK: Определяет, является ли строка рациональным числом.
    private func isRational(variable: String) -> Bool {
        if variable.isEmpty {
            return false
        }
        if let _ = Double(variable) {
            return true
        } else {
            return false
        }
//        for c in variable {
//            if !c.isNumber && c != "." {
//                return false
//            }
//        }
//        return true
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
        var coutnSquareBreckets = 0
        var countRoundBrackes = 0
        var countFunction = 0
        var prev: Character = "("
        for char in line {
            if char == "[" {
                coutnSquareBreckets += 1
            } else if char == "]" {
                coutnSquareBreckets -= 1
            }
            if char == "(" && prev.isLetter {
                countFunction += 1
            } else if char == ")" && countRoundBrackes == 0 && countFunction != 0 {
                countFunction -= 1
                if countFunction == 0 {
                    string += String(char)
                    prev = char
                    continue
                }
            } else if char == "(" && countFunction != 0 {
                countRoundBrackes += 1
            } else if char == ")" && countFunction != 0 {
                countRoundBrackes -= 1
            }
            if "+-".contains(char) && prev == "(" {
                string += " \(char)"
            } else if "+-*/%()^@".contains(char) && coutnSquareBreckets == 0 && countFunction == 0 {
                string += " \(char) "
            } else {
                string += String(char)
            }
            prev = Character(extendedGraphemeClusterLiteral: char)
        }
        return string
    }
    
    // MARK: Разделяет строку на слова по пробелам и возвращает массив слов
    func getWords() -> [String] {
        return self.split() { $0 == " " }.map{ String($0) }
    }
}
