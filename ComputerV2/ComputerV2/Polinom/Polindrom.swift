//
//  Polindrom.swift
//  ComputerV1
//
//  Created by Михаил Фокин on 24.02.2021.
//

import Foundation

class Polindrom: NSObject {
    var monoms = [Monom]()
    
    override var description: String { return getReducedForm() }
    
    init(polindrom: String) {
        super.init()
        let polinomsLiftRight = Polindrom.getLeftRightPolinoms(polindrom: polindrom)
        var polindrom = [Monom]()
        for monom in polinomsLiftRight.0 {
            polindrom.append(Monom(monom: monom))
        }
        for monom in polinomsLiftRight.1 {
            let temp = Monom(monom: monom)
            temp.coefficient = -temp.coefficient
            polindrom.append(temp)
        }
        monoms = reductionSuchTerms(polindrom: polindrom)
    }
    
    private func reductionSuchTerms(polindrom: [Monom]) -> [Monom] {
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
        return polindrom.sorted(by: {$0.degree > $1.degree})
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
}
