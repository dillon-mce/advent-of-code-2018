#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY "
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1


let test1 = ""
//assert(produceCheckSum(on: test1) == 12)

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

