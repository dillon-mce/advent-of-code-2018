#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 1"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
func calculateFrequency(_ string: String) -> Int {
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
    
    return result
}

let test1 = "+1 -2 +3 +1"
assert(calculateFrequency(test1) == 3)

// Part 2
func calculateFirstReusedFreq(_ string: String) -> Int {
    let array = string.components(separatedBy: .whitespacesAndNewlines)
    var result: Int? = nil
    var frequency = 0
    let characterSet = CharacterSet(charactersIn: "+-")
    var frequenciesHit: Set<Int> = Set(arrayLiteral: 0)
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
            if frequenciesHit.contains(frequency) {
                result = frequency
                break
            }
            frequenciesHit.insert(frequency)
        }
    }
    //print("\(count) times through the loop!")
    return result!
}

let test2 = test1
assert(calculateFirstReusedFreq(test2) == 2)

func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }
    
    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = calculateFrequency(string)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
    
    if string == test1 { string = test2 }
    
    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = calculateFirstReusedFreq(string)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}


findAnswers(input)

