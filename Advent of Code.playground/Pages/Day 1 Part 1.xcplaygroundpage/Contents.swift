import UIKit


func calculateFrequency(_ string: String) -> Int {
    let startTime = CFAbsoluteTimeGetCurrent()
    let array = string.components(separatedBy: .whitespacesAndNewlines)
    var result = 0
    let characterSet = CharacterSet(charactersIn: "+-")
    
//    for element in array {
//        guard let number = Int(element.components(separatedBy: characterSet).joined()) else { continue }
//        if element.first == "+" {
//            result += number
//        } else if element.first == "-" {
//            result -= number
//        }
//    }
    
    let additions = array.filter({ $0.hasPrefix("+") }).compactMap() {Int($0.components(separatedBy: characterSet).joined())}
    let subtractions = array.filter({ $0.hasPrefix("-") }).compactMap() {Int($0.components(separatedBy: characterSet).joined())}
    
    result = additions.reduce(result, +)
    result = subtractions.reduce(result, -)
    
    print("Answer: \(result)")
    print("Took \(CFAbsoluteTimeGetCurrent() - startTime) seconds to find an answer")
    return result
}



let test1 = "+1, -2, +3, +1"
calculateFrequency(test1)
calculateFrequency("+3 -12 +54")

calculateFrequency(day1Input)
