#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 5"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
func collapsePolymer(_ string: String) -> String {
    var array = Array(string)
    var madeFullPass = false
    var madeToIndex = 0
    
    while !madeFullPass {
        for i in madeToIndex..<array.count - 1 {
            let firstLetter = String(array[i])
            let secondLetter = String(array[i+1])
            if firstLetter.lowercased() == secondLetter.lowercased() && firstLetter != secondLetter {
                array.remove(at: i)
                array.remove(at: i)
                madeToIndex = i > 1 ? i - 2 : 0
                break
            } else if i == array.count-2 {
                madeFullPass = true
            }
        }
    }
    return String(array)
}

let test1 = "dabAcCaCBAcCcaDA"
assert(collapsePolymer(test1).count == 10)

// Part 2
func testWithoutCertainLetters(_ string: String) -> Int {
    let letters = Set(Array(string.lowercased()))
    var resultsDict: [Character: String] = [:]
    
    for letter in letters {
        let array = Array(string).filter() { String($0).lowercased() != String(letter) }
        let result = collapsePolymer(String(array))
        resultsDict[letter] = result
    }
    
    let answer = resultsDict.min(by: { $0.value.count < $1.value.count })
    return answer?.value.count ?? -1
}

let test2 = test1
assert(testWithoutCertainLetters(test2) == 4)

func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }

    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = collapsePolymer(string)
    print("Part 1 Answer: \(answer1.count)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")

    if string == test1 { string = test2 }

    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = testWithoutCertainLetters(string)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}


findAnswers(input)


