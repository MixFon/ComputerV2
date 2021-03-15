//
//  Variable.swift
//  ComputerV2
//
//  Created by Михаил Фокин on 15.03.2021.
//

import Foundation

class Variable {
    var name: String
    var value: TypeProtocol?
    
    init() {
        self.name = ""
    }
    
    init(name: String) {
        self.name = name.lowercased()
    }
    
}
