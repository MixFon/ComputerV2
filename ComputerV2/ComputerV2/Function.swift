//
//  Function.swift
//  ComputerV2
//
//  Created by Михаил Фокин on 19.03.2021.
//

import Foundation

class Function: TypeProtocol {
    var expression: String
    var argument: String
    
    var syntaxValueType: String { return expression }
    
    var fraction: String { return expression }
    
    required init(expression: String) throws {
        self.expression = expression
        self.argument = String()
    }
    
    init(argument: String, expression: String) {
        self.expression = expression
        self.argument = argument
    }
    
    var valueType: String {
        return self.expression
    }
    
}
