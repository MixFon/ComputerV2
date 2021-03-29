//
//  Extension.swift
//  ComputerV2
//
//  Created by Михаил Фокин on 29.03.2021.
//

// MARK: Файл с расширением стандартных типов данных.
import Foundation

// MARK: Расширение типа String
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
            } else if "+-*/%()^@?".contains(char) && coutnSquareBreckets == 0 && countFunction == 0 {
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

// MARK: Расширениее типа Double.
extension Double {
    func toInt() -> Int? {
        let minInt = Double(Int.min)
        let maxInt = Double(Int.max)

        guard case minInt ... maxInt = self else {
            return nil
        }

        return Int(self)
    }
}
