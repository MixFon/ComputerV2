//
//  Polindrom.swift
//  ComputerV1
//
//  Created by Михаил Фокин on 24.02.2021.
//

import Foundation

class Polinom: NSObject {
    var monoms = [Monom]()
    
    override var description: String { return getReducedForm() }
    
    override init() {
        self.monoms = []
    }
    
    init(monoms: [Monom]) {
        self.monoms = monoms
    }
    
    init(polinom: Polinom) {
        self.monoms = polinom.monoms
    }
    
    init(monom: Monom) {
        self.monoms.append(monom)
    }
    
    init(polindrom: String) {
        super.init()
        let polinomsLiftRight = Polinom.getLeftRightPolinoms(polindrom: polindrom)
        var polindrom = [Monom]()
        for monom in polinomsLiftRight.0 {
            polindrom.append(Monom(monom: monom))
        }
        for monom in polinomsLiftRight.1 {
            let temp = Monom(monom: monom)
            temp.coefficient = -temp.coefficient
            polindrom.append(temp)
        }
        reductionSuchTerms(polindrom: polindrom)
    }
    
    // MARK: Приведение подобных слакаемых.
    private func reductionSuchTerms(polindrom: [Monom]) {
        var dictMonom = [Int: Double]()
        for monom in polindrom {
            if let value = dictMonom[monom.degree] {
                dictMonom[monom.degree] = monom.coefficient + value
            } else {
                dictMonom[monom.degree] = monom.coefficient
            }
        }
        var polindrom = [Monom]()
        for monom in dictMonom {
            polindrom.append(Monom(coefficient: monom.value, degree: monom.key))
        }
        polindrom = polindrom.filter({$0.coefficient != 0})
        self.monoms = polindrom.sorted(by: {$0.degree > $1.degree})
    }
    
    // MARK: Приведение подобных слакаемых. Перегруженный.
    private func reductionSuchTerms() {
        self.reductionSuchTerms(polindrom: self.monoms)
    }
    
    func getReducedForm() -> String {
        var reduceForm = String()
        for monom in monoms {
            reduceForm += "\(monom)"
        }
        if reduceForm.first == "+" {
            reduceForm = String(reduceForm.dropFirst())
        }
        return reduceForm
    }
    
    func getPolynominalDegree() -> Int {
        return (monoms.first?.degree ?? 0)
    }
    
    static func getLeftRightPolinoms(polindrom: String) -> ([String], [String]) {
        var withoutWhitespace = polindrom.removeWhitespace().uppercased()
        if !withoutWhitespace.contains("=") {
            withoutWhitespace += "=0"
        }
        if withoutWhitespace.first == "=" {
            withoutWhitespace = "0" + withoutWhitespace
        }
        if withoutWhitespace.last == "=" {
            withoutWhitespace += "0"
        }
        let polindromStringArray = withoutWhitespace.split() {$0 == "="}.map{ String($0) }
        let leftPolindrom = addSpaceBeforePlus(polindromString: polindromStringArray[0])
        let rightPolindrom = addSpaceBeforePlus(polindromString: polindromStringArray[1])
        let arrMonomsLeft = leftPolindrom.split() { $0 == " " }.map{ String($0)}
        let arrMonomsRight = rightPolindrom.split() { $0 == " " }.map{ String($0)}
        return (arrMonomsLeft, arrMonomsRight)
    }
    
    static func addSpaceBeforePlus(polindromString: String) -> String {
        var string = String()
        for char in polindromString {
            if char == "+" || char == "-" {
                string += " "
            }
            string += String(char)
        }
        return string
    }
    
    func addMonom(monom: Monom) {
        self.monoms.append(monom)
        self.reductionSuchTerms()
    }
}

extension Polinom {
    
    //MARK: Сложение двух полиномов.
    static func + (left: Polinom, right: Polinom) -> Polinom {
        let polinom = Polinom(monoms: left.monoms + right.monoms)
        polinom.reductionSuchTerms(polindrom: polinom.monoms)
        return polinom
    }
    
    static func - (left: Polinom, right: Polinom) -> Polinom {
        let inverseRightPolinim = Polinom(polinom: -right)
        let polinom = Polinom(monoms: left.monoms + inverseRightPolinim.monoms)
        polinom.reductionSuchTerms(polindrom: polinom.monoms)
        return polinom
    }
    
    //MARK: Перемена знака у всего полинома.
    static prefix func - (polinom: Polinom) -> Polinom {
        let newPolinom = Polinom()
        for monom in polinom.monoms {
            newPolinom.monoms.append(-monom)
        }
        return newPolinom
    }
    
    //MARK: Умножение двух полиномов.
    static func * (left: Polinom, right: Polinom) -> Polinom {
        let polinom = Polinom()
        for leftMonom in left.monoms {
            for rightMonom in right.monoms {
                polinom.monoms.append(leftMonom * rightMonom)
            }
        }
        polinom.reductionSuchTerms(polindrom: polinom.monoms)
        return polinom
    }
    
    //MARK: Возведение в степень подинома.
    static func ^ (left: Polinom, right: Polinom) throws -> Polinom {
        let error = "The degree of the polynomial must be an integer."
        var newPolinom = Polinom(polinom: left)
        if right.monoms.count != 1 {
            throw Exception(massage: error)
        }
        guard let degree = right.monoms.first?.coefficient else {
            throw Exception(massage: error)
        }
        let numDen = try Rational().getNumeratorDenuminator(degree)
        if numDen.1 != 1 {
            throw Exception(massage: error)
        }
        for _ in 1..<numDen.0 {
            newPolinom = newPolinom * left
        }
        newPolinom.reductionSuchTerms(polindrom: newPolinom.monoms)
        return newPolinom
    }
}
