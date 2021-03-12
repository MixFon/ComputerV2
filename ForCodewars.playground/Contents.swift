//import Cocoa
//import Foundation

func validBraces(_ string:String) -> Bool {
    var stack = String()
    let dict = [")":"(", "}":"{", "]":"["]
    for c in string {
        if "({[".contains(c) {
            stack.append(c)
        } else if ")}]".contains(c) {
            if stack.isEmpty {
                return false
            }
            guard let value = dict[String(c)] else { return false}
            guard let last = stack.popLast() else { return false }
            if String(last) != value {
                return false
            }
        }
    }
    return true
}
print("Hello")
validBraces("(){}[]")
validBraces("([{}])")
validBraces("(}")
validBraces("[(])")
validBraces("[({})](]")

validBraces("([{}])")
validBraces("(}")
validBraces("[(])")
validBraces("({})[({})]")
validBraces("(})")
validBraces("(({{[[]]}}))")
validBraces("{}({})[]")
validBraces(")(}{][")
validBraces("())({}}{()][][")
validBraces("(((({{")
validBraces("}}]]))}])")
//"(){}[]"   =>  True
//"([{}])"   =>  True
//"(}"       =>  False
//"[(])"     =>  False
//"[({})](]" =>  False
