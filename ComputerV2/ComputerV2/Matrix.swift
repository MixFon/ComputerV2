//
//  Matrix.swift
//  ComputerV2
//
//  Created by Михаил Фокин on 11.03.2021.
//

import Foundation

class Matrix {
    var matrix: [[Rational]]
    var rows: Int { return matrix.count }
    var colums: Int { return matrix.first?.count ?? 0}

    init() {
        self.matrix = [[Rational]]()
    }
    
    init(rows: Int, colums: Int) {
        self.matrix = Array(repeating: Array(repeating: Rational(), count: colums), count: rows)
        //var arr = Array(count: 3, repeatedValue: Array(count: 2, repeatedValue: 0))
    }
    
    // MARK: Коструктора преобразования матрицу в виде строки в матрицу рациональных чисел
    convenience init(matrix: String) throws {
        let massageError = "Invalid matrix syntax."
        var matrix = matrix
        self.init()
        if matrix.first != "[" || matrix.last != "]" {
            throw Exception(massage: massageError)
        }
        matrix.remove(at: matrix.index(before: matrix.endIndex))
        matrix.remove(at: matrix.startIndex)
        let rows = matrix.split() {$0 == ";"}.map{ String($0) }
        for row in rows {
            var rowRational = [Rational]()
            var row = row
            if row.first != "[" || row.last != "]" {
                throw Exception(massage: massageError)
            }
            row.remove(at: row.index(before: row.endIndex))
            row.remove(at: row.startIndex)
            if row.isEmpty {
                throw Exception(massage: massageError)
            }
            let elements = row.split(){ $0 == "," }.map{ String($0) }
            if row.filter({$0 == ","}).count + 1 != elements.count {
                throw Exception(massage: massageError)
            }
            for element in elements {
                guard let element = Double(element) else {
                    throw Exception(massage: massageError)
                }
                rowRational.append(Rational(element))
            }
            self.matrix.append(rowRational)
        }
        let colums = self.matrix[0].count
        for row in self.matrix {
            if row.count != colums {
                throw Exception(massage: massageError)
            }
        }
    }
    
    // MARK: Вывод матрицы
    func printMatrix() {
        print("rows: \(self.rows) colums: \(self.colums)")
        for row in self.matrix {
            print(row)
        }
    }
    
}

// MARK: Оператор сложения матриц.
func + (left: Matrix, right: Matrix) throws -> Matrix {
    if left.rows != right.rows || left.colums != right.colums {
        throw Exception(massage: "Error: Matrices of different dimention.")
    }
    let result = Matrix()
    for (left, right) in zip(left.matrix, right.matrix) {
        var row = [Rational]()
        for (le, ri) in zip(left, right) {
            row.append(le + ri)
        }
        result.matrix.append(row)
    }
    return result
}

// MARK: Оператор вычитания матриц.
func - (left: Matrix, right: Matrix) throws -> Matrix {
    if left.rows != right.rows || left.colums != right.colums {
        throw Exception(massage: "Error: Matrices of different dimention.")
    }
    let result = Matrix()
    for (left, right) in zip(left.matrix, right.matrix) {
        var row = [Rational]()
        for (le, ri) in zip(left, right) {
            row.append(le - ri)
        }
        result.matrix.append(row)
    }
    return result
}

// MARK: Оператор умножения матрицы на Rational.
func * (matrix: Matrix, rational: Rational) -> Matrix {
    let result = Matrix()
    for row in matrix.matrix {
        var newRow = [Rational]()
        for element in row {
            newRow.append(element * rational)
        }
        result.matrix.append(newRow)
    }
    return result
}

// MARK: Оператор умножения матрицы на матрицу.
func * (left: Matrix, right: Matrix) throws -> Matrix {
    if left.colums != right.rows {
        throw Exception(massage: "The matrices cannot be rearranged, since their dimensions do not match.")
    }
    let result = Matrix(rows: left.rows, colums: right.colums)
    print(result.printMatrix())
    return result
}

// MARK: Оператор сравнения матриц.
func == (left: Matrix, right: Matrix) -> Bool {
    if left.rows != right.rows || left.colums != right.colums {
        return false
    }
    for (left, right) in zip(left.matrix, right.matrix) {
        for (le, ri) in zip(left, right) {
            if le != ri {
                return false
            }
        }
    }
    return true
}

// MARK: Оператор не равно матриц.
func != (left: Matrix, right: Matrix) -> Bool {
    return !(left == right)
}
