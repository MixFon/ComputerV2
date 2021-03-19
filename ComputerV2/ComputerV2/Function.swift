//
//  Function.swift
//  ComputerV2
//
//  Created by Михаил Фокин on 19.03.2021.
//

import Foundation

class Function: TypeProtocol {
    
    var expression: String
    
    required init(expression: String) throws {
        self.expression = expression
    }
    
    var valueType: String {
        return self.expression
    }
    
    
}
