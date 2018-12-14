#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 7"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
func figureOutOrder(_ string: String) -> String {
    let array = string.components(separatedBy: CharacterSet(charactersIn: "\n"))
    var dependencyDict: [String: [String]] = [:]
    var letterArray: [String] = []
    var letterSet: Set<String> = Set()
    for line in array {
        let letters = line.components(separatedBy: .whitespaces).filter() { $0.count == 1 }
        dependencyDict[letters[1], default: []].append(letters[0])
        for i in 0...1 {
            if !letterSet.contains(letters[i]) {
                letterSet.insert(letters[i])
                letterArray.append(letters[i])
            }
        }
        
    }
    letterArray.sort()
    var completedSet: Set<String> = Set()
    var results: [String] = []
    while letterArray.count > 0 {
        for index in 0..<letterArray.count {
            let letter = letterArray[index]
            let dependencies = dependencyDict[letter]?.filter() { !completedSet.contains($0) }
            if dependencies == nil || dependencies == [] {
                completedSet.insert(letter)
                results.append(letter)
                letterArray.remove(at: index)
                break
            }
        }
    }
    return results.joined()
}

let test1 = """
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
"""


assert(figureOutOrder(test1) == "CABDFE")

// Part 2


let test2 = ""
//assert(answerPart2(test2) == "")

//func findAnswers(_ string: String) {
//    var string = string
//    if string.isEmpty { string = test1 }
//
//    var startTime = CFAbsoluteTimeGetCurrent()
//    // update function here
//    let answer1 = produceCheckSum(on: string)
//    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
//
//    if string == test1 { string = test2 }
//
//    startTime = CFAbsoluteTimeGetCurrent()
//    // update function here
//    let answer2 = answerPart2(string)
//    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
//}


//findAnswers(input)


