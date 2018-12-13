#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 2"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
@discardableResult func produceCheckSum(on string: String) -> Int {
    let array = string.components(separatedBy: .whitespacesAndNewlines)
    let contains2 = array.filter() { containsMultiples($0, count: 2) }.count
    let contains3 = array.filter() { containsMultiples($0, count: 3) }.count
    
    let result = contains2 * contains3
    return result
    
}

func containsMultiples(_ string: String, count: Int) -> Bool {
    let letters = Set(string)
    for letter in letters {
        let filtered = string.filter() { $0 == letter }
        if filtered.count == count { return true }
    }
    return false
}

let test1 = "abcdef bababc abbcde abcccd aabcdd abcdee ababab"
assert(produceCheckSum(on: test1) == 12)

// Part 2
func matchAllButOne(_ string: String) -> [String] {
    let array = string.components(separatedBy: .whitespacesAndNewlines)
    for string1 in array {
        let filtered = array.filter() { filterString(string1, $0) }
        if filtered.count > 1 { return filtered }
    }
    return []
}

func filterString(_ string1: String, _ string2: String) -> Bool {
    var mismatches = 0
    let array1 = Array(string1)
    let array2 = Array(string2)
    for i in 0..<string1.count {
        if array1[i] != array2[i] { mismatches += 1 }
    }
    return mismatches < 2
}

@discardableResult func answerPart2(_ string: String) -> String {
    let array = matchAllButOne(string)
    var string = ""
    
    let array1 = Array(array[0])
    let array2 = Array(array[1])
    for i in 0..<array1.count {
        if array1[i] == array2[i] { string += String(array1[i]) }
    }
    
    return string
}

func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }
    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = produceCheckSum(on: string)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
    
    if string == test1 { string = test2 }
    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = answerPart2(string)
    
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}

let test2 = "abcde fghij klmno pqrst fguij axcye wvxyz"
assert(answerPart2(test2) == "fgij")

findAnswers(input)