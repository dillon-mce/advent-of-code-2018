import UIKit


func calculateFreq(_ string: String) -> Int {
    let array = string.components(separatedBy: .whitespacesAndNewlines)
    var result = 0
    let characterSet = CharacterSet(charactersIn: "+-")
    
    for element in array {
        guard let number = Int(element.components(separatedBy: characterSet).joined()) else { continue }
        if element.first == "+" {
            result += number
        } else if element.first == "-" {
            result -= number
        }
    }
    
    return result
}


calculateFreq(day1Input)

let test1 = "+1 +1 +1"

calculateFreq(test1)

calculateFreq("+3 -12 +54")
