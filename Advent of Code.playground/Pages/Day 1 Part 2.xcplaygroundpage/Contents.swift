import UIKit

func calculateFreq(_ string: String) -> Int? {
    let array = string.components(separatedBy: .whitespacesAndNewlines)
    var result: Int? = nil
    var frequency = 0
    let characterSet = CharacterSet(charactersIn: "+-")
    var frequenciesHit: [Int] = [0]
    var count = 0
    
    while result == nil {
        count += 1
        for element in array {
            // Get the number without the plus or minus sign as an Int
            guard let number = Int(element.components(separatedBy: characterSet).joined()) else { continue }
            if element.first == "+" {
                // If it is marked by a plus sign, add it
                frequency += number
            } else if element.first == "-" {
                // Otherwise if it is marked by a minus sign, subtract it
                frequency -= number
            }
            if frequenciesHit.contains(frequency) { return frequency }
            frequenciesHit.append(frequency)
        }
        print("\(count) times through the loop!")
    }
    
    return result
}

let test1 = "+1 -1 +1"
calculateFreq(test1)

calculateFreq(day1Input)



//calculateFreq("+3 -12 +54")

