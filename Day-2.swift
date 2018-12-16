#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 2"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
func produceCheckSum(_ string: String) -> Int {
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
assert(produceCheckSum(test1) == 12)

// Part 2
func filterString(_ string1: String, _ string2: String) -> Bool {
    var mismatches = 0
    let array1 = Array(string1)
    let array2 = Array(string2)
    for i in 0..<string1.count {
        if array1[i] != array2[i] { mismatches += 1 }
    }
    return mismatches < 2
}

func findCommonLetters(_ string: String) -> String {
    let array = string.components(separatedBy: .whitespacesAndNewlines)
    var resultString = ""
    var filtered: [String] = []
    
    for ID in array {
        filtered = array.filter() { filterString(ID, $0) }
        if filtered.count > 1 { break }
    }
    
    let array1 = Array(filtered[0])
    let array2 = Array(filtered[1])
    for i in 0..<array1.count {
        if array1[i] == array2[i] { resultString += String(array1[i]) }
    }
    
    return resultString
}

let test2 = "abcde fghij klmno pqrst fguij axcye wvxyz"
assert(findCommonLetters(test2) == "fgij")

func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }
    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = produceCheckSum(string)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
    
    if string == test1 { string = test2 }
    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = findCommonLetters(string)
    
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}


findAnswers(input)
