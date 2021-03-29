//
//  ComputerV2.swift
//  ComputerV2
//
//  Created by Михаил Фокин on 04.03.2021.
//

import Foundation

class Computer {
    
    var variables: [Variable]
    
    var fraction = false
    
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
            if !keywordProcessing(line: lineWithoutSpace) { continue }
            if !checkErrors(line: lineWithoutSpace) { continue }
            if !workingLine(line: lineWithoutSpace) { continue }
        }
    }
    
    // MARK: Обработка ключевых слов.
    private func keywordProcessing(line: String) -> Bool {
        switch line {
        case "exit":
            exit(0)
        case "ls":
            printVariables()
            return false
        case "help", "-h":
            printHelp()
            return false
        case "fraction", "-f":
            self.fraction = !(self.fraction)
            return false
        default:
            return true
        }
    }
    
    // MARK: Вывести подсказку.
    private func printHelp() {
        print("Syntax:")
        print("variableName = value")
        print("Types: Rational, Imaginary, Matrix, Functiona.")
        print("Matrix: MxN")
        print("[[A0,A1,A2,...,An];[B0,B1,B2,...,Bn];...;[M0,M1,M2,...,Mn]]")
        print("Function:")
        print("functionName(functionVariable) = expression")
        print("Calculating the value:")
        print("expression = ?")
        print("Solution of the equation.")
        print("functionName(functionVariable) = expression ?")
        print()
        print("Keywords:")
        print("ls \t\t Print list variables.")
        print("help(-h) \t Print help.")
        print("fraction(-f) \t Displaying numbers as fractions.")
        print("exit \t\t Exit the program.")
    }
    
    // MARK: Выводит на экран список переменных и функций
    private func printVariables() {
        if self.variables.isEmpty {
            print("There are no variable.")
            return
        }
        let variables = self.variables.filter{ !($0.value is Function) }
        let functions = self.variables.filter{ $0.value is Function }
        if !variables.isEmpty {
            print("Variables:")
            for variable in variables {
                guard let value = variable.value else { continue }
                let valueType: String
                if self.fraction {
                    valueType = value.fraction
                } else {
                    valueType = value.valueType
                }
                var separator = String()
                if variable.value is Matrix {
                    separator = "\n"
                }
                print("\(variable.name) = \(separator)\(valueType)")
            }
        }
        if !functions.isEmpty {
            print("Functions:")
            for function in functions {
                guard let functionType = function.value as? Function else { continue }
                let valueType = functionType.valueType
                let nameFunction = function.name.dropLast(1)
                print("\(nameFunction)\(functionType.argument)) = \(valueType)")
            }
        }
    }
    
    // MARK: Распредение на вывод значения или создания новой переменной.
    private func workingLine(line: String) -> Bool {
        do {
            if line.contains("?") {
                try computation(line: line)
            } else {
                try addVariable(line: line)
            }
        } catch let exception as Exception {
            systemError(massage: exception.massage)
            return false
        } catch {}
        return true
    }
    
    // MARK: Вычисление значения переменных или решение уравнений.
    private func computation(line: String) throws {
        if line.last != "?" {
            throw Exception(massage: "The question mark character must be at the end of the line.")
        }
        let line = line.dropLast(1)
        let leftRight = line.split() { $0 == "=" }.map { String($0) }
        if leftRight.count == 1 {
            try computationVariable(expression: leftRight.first!)
        } else {
            try solveEquation(leftRight: leftRight)
        }
    }
    
    // MARK: Вычисление значения выражения {variable}=?. Вывод на экран без создания новой перемнной.
    private func computationVariable(expression: String) throws {
        let value = try getCalculateValue(expression: expression)
        try printVariableValue(value: value)
    }
    
    // MARK: Решить уравнение. {function(value)} = {rationalValue} ?
    private func solveEquation(leftRight: [String]) throws {
        if leftRight.count != 2 {
            throw Exception(massage: "Error in solving the equation.")
        }
        let rightValue = try getCalculateValue(expression: leftRight.last!)
        guard let rational = rightValue as? Rational else {
            throw Exception(massage: "Error: \(leftRight.last!). The expression on the right must be a rational number.")
        }
        let nameFunction: String
        let argumentFunctions: String
        (nameFunction, argumentFunctions) = try splitNameArgumenrFunction(function: leftRight.first!)
        guard let function = try getExistingVariable(variable: "\(nameFunction)()") as? Function else {
            throw Exception(massage: "Error: \(nameFunction)() function does not exist.")
        }
        if function.argument != argumentFunctions {
            throw Exception(massage: "Error \(argumentFunctions). Invalid function argument.")
        }
        let polinom = try getCalculatePolinom(expression: function.expression, argument: argumentFunctions)
        polinom.addMonom(monom: Monom(coefficient: -rational.rational, degree: 0))
        _ = Equation(polinom: polinom)
    }
    
    // MARK: Приведение полинома к стандартному виду. ax^2+bx+c
    private func getCalculatePolinom(expression: String, argument: String) throws -> Polinom {
        let postfixForm = conversionPostfixForm(infixFomr: expression)
        let polinom = try calculatePolinom(postfixForm: postfixForm, argument: argument)
        print(polinom.getReducedForm())
        return polinom
    }
    
    // MARK: Проведение операций над полиномом.
    func calculatePolinom(postfixForm: String, argument: String) throws -> Polinom {
        var stack = [Polinom]()
        let elements = postfixForm.split() { $0 == " "}.map{ String($0) }
        for element in elements {
            switch element {
            case "+":
                guard let secondValue = stack.popLast(), let firstValue = stack.popLast() else {
                    throw Exception(massage: "Invalid operand polinom: \(element)")
                }
                stack.append(firstValue + secondValue)
            case "-":
                guard let secondValue = stack.popLast(), let firstValue = stack.popLast() else {
                    throw Exception(massage: "Invalid operand polinom: \(element)")
                }
                stack.append(firstValue - secondValue)
            case "*":
                guard let secondValue = stack.popLast(), let firstValue = stack.popLast() else {
                    throw Exception(massage: "Invalid operand polinom: \(element)")
                }
                stack.append(firstValue * secondValue)
            case "^":
                guard let secondValue = stack.popLast(), let firstValue = stack.popLast() else {
                    throw Exception(massage: "Invalid operand polinom: \(element)")
                }
                stack.append(try firstValue ^ secondValue)
            default:
                if element == argument {
                    let polinom = Polinom(monom: Monom(monom: "X"))
                    stack.append(polinom)
                    break
                }
                let newValue = try createElementTypeProtocol(variable: element)
                guard let rational = newValue as? Rational else {
                   throw Exception(massage: "Error \(element). The expression must be of a rational type.")
                }
                let polinom = Polinom(monom: Monom(coefficient: rational.rational, degree: 0))
                stack.append(polinom)
            }
        }
        guard let last = stack.popLast() else {
            throw Exception(massage: "Invalid operand expression.")
        }
        return last
    }
    
    
    // MARK: Создание или обновление переменной и добавления в список переменных.
    private func addVariable(line: String) throws {
        let leftRight = line.split() { $0 == "=" }.map { String($0) }
        let nameVariable = leftRight.first!
        try checkValidName(name: nameVariable)
        try checkExistingAgrumentFunction(name: nameVariable)
        let newVariable: Variable
        if isFunction(variable: nameVariable) {
            let nameFunction: String
            let argumentFunctions: String
            (nameFunction, argumentFunctions) = try splitNameArgumenrFunction(function: nameVariable)
            try checkArgumentFunction(argument: argumentFunctions)
            newVariable = Variable(name: "\(nameFunction)()")
            newVariable.value = Function(argument: argumentFunctions, expression: leftRight.last!)
        } else {
            newVariable = Variable(name: nameVariable)
            newVariable.value = try getCalculateValue(expression: leftRight.last!)
        }
        updateVariables(newVariable: newVariable)
        try printVariableValue(value: newVariable.value)
    }
    
    // MARK: Печатает значение переменной. В дробной или обычной форме.
    private func printVariableValue(value: TypeProtocol?) throws {
        guard let value = value else {
            throw Exception(massage: "Invalid print value.")
        }
        if self.fraction {
            print(value.fraction)
        } else {
            print(value.valueType)
        }
    }
    
    // MARK: Переводит выражение из инфиксной формы в постфиксную и возвращает объект R, I, M
    private func getCalculateValue(expression: String) throws -> TypeProtocol {
        let postfixForm = conversionPostfixForm(infixFomr: expression)
        return try calculateValue(postfixForm: postfixForm)
    }
    
    // MARK: Имя переменной не должно совпадать с именем аргумента любой функции.
    private func checkExistingAgrumentFunction(name: String) throws {
        for variable in self.variables {
            if let function = variable.value as? Function {
                if function.argument == name {
                    throw Exception(massage: "Error: \(name) The variable name must not match the name of the fuction argument.")
                }
            }
        }
    }
    
    // MARK: Имя аргумента не должно совпадать и именами переменных, а так же цифр и операторов.
    private func checkArgumentFunction(argument: String) throws {
        for variable in self.variables {
            if variable.name == argument {
                throw Exception(massage: "Error name argument: \(argument). The argument name mist not match the name of an existing variable.")
            }
        }
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
        let type = try getTypeVariable(variable: variable)
        switch type {
        case .rational:
            return try Rational(expression: variable)
        case .imaginary:
            return try Imaginary(expression: variable)
        case .matrix:
            return try Matrix(expression: variable)
        case .variable:
            return try getExistingVariable(variable: variable)
        case .function:
            let nameFunction: String
            let argumentFunctions: String
            (nameFunction, argumentFunctions) = try splitNameArgumenrFunction(function: variable)
            let intermediateVatiable = try getCalculateValue(expression: argumentFunctions)
            let syntaxValueType = "(\(intermediateVatiable.syntaxValueType))".removeWhitespace()
            let postfixFormSyntaxVT = conversionPostfixForm(infixFomr: syntaxValueType)
            let function = try getExistingVariable(variable: "\(nameFunction)()") as! Function
            var postfisFormFunctionExpression = conversionPostfixForm(infixFomr: function.expression)
            postfisFormFunctionExpression += " "
            postfisFormFunctionExpression = postfisFormFunctionExpression.replace(string: "\(function.argument) ", replacement: "\(postfixFormSyntaxVT) ")
            return try calculateValue(postfixForm: postfisFormFunctionExpression)
        default:
            throw Exception(massage: "Invalid value: \(variable)")
        }
    }
    
    private func getExistingVariable(variable: String) throws -> TypeProtocol {
        for existingVariable in self.variables {
            if existingVariable.name == variable {
                guard let value =  existingVariable.value else {
                    throw Exception(massage: "Invalig existing value.")
                }
                return value
            }
        }
        return Rational(0)
    }
    
    // MARK: Разделяет имя функции и ее аргумент на две строки и возвращвет в виде кортежа.
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
        if argument.isEmpty {
            throw Exception(massage: "The function argument is missing.")
        }
        return (String(name), String(argument))
    }
    
    // MARK: Определить тип: рациональное число, комплекское, матрица, существующая переменая/функция, ошибка.
    private func getTypeVariable(variable: String) throws -> TypeVariable {
        if isRational(variable: variable) {
            return .rational
        }
        if isImaginary(variable: variable) {
            return .imaginary
        }
        if isMatrix(variable: variable) {
            return .matrix
        }
        if try isExistingVariable(variable: variable) {
            if isFunction(variable: variable){
                return .function
            } else {
                return .variable
            }
        }
        return .error
    }
    
    // MARK: Определяем является ли переданное имя переменной имемен функции. Содержит ли ()
    private func isFunction(variable: String) -> Bool {
        return variable.contains("(") && variable.last == ")"
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
    private func isExistingVariable(variable: String) throws -> Bool {
        var variable = variable
        if isFunction(variable: variable){
            let function = try splitNameArgumenrFunction(function: variable)
            variable = "\(function.0)()"
        }
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
