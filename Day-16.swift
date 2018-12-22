#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 16"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
struct RegisterSet: CustomStringConvertible {
    var index0: Int
    var index1: Int
    var index2: Int
    var index3: Int
    
    var description: String {
        return "[\(index0), \(index1), \(index2), \(index3)]"
    }
    
    static func == (lhs: RegisterSet, rhs: RegisterSet) -> Bool {
        return lhs.index0 == rhs.index0 &&
        lhs.index1 == rhs.index1 &&
        lhs.index2 == rhs.index2 &&
        lhs.index3 == rhs.index3
    }
    
    subscript(_ member: Int) -> Int {
        get {
            switch member {
            case 0: return self.index0
            case 1: return self.index1
            case 2: return self.index2
            case 3: return self.index3
            default: return 0
            }
        }
        set(newValue) {
            switch member {
            case 0: self.index0 = newValue
            case 1: self.index1 = newValue
            case 2: self.index2 = newValue
            case 3: self.index3 = newValue
            default: return
            }

        }
    }
}

// Add methods
func addr(_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet {
    var result = registerSet
    let newValue = instruction[instruction[1]] + instruction[instruction[2]]
    result[2] = newValue
    return result
}

func addi(_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet {
    var result = registerSet
    let newValue = instruction[instruction[1]] + instruction[2]
    result[2] = newValue
    return result
}

// Multiply methods
func mulr(_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet {
    var result = registerSet
    let newValue = instruction[instruction[1]] * instruction[instruction[2]]
    result[2] = newValue
    return result
}

func muli(_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet {
    var result = registerSet
    let newValue = instruction[instruction[1]] * instruction[2]
    result[2] = newValue
    return result
}

// Bitwise methods
func banr(_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet {
    var result = registerSet
    let newValue = instruction[instruction[1]] & instruction[instruction[2]]
    result[2] = newValue
    return result
}

func bani(_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet {
    var result = registerSet
    let newValue = instruction[instruction[1]] & instruction[2]
    result[2] = newValue
    return result
}

func borr(_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet {
    var result = registerSet
    let newValue = instruction[instruction[1]] | instruction[instruction[2]]
    result[2] = newValue
    return result
}

func bori(_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet {
    var result = registerSet
    let newValue = instruction[instruction[1]] | instruction[2]
    result[2] = newValue
    return result
}

func parseInput(_ string: String) {
    let array = string.components(separatedBy: .newlines)
    let before = RegisterSet(index0: 3, index1: 2, index2: 1, index3: 1)
    let instruction = RegisterSet(index0: 9, index1: 2, index2: 1, index3: 2)
    let after = RegisterSet(index0: 3, index1: 2, index2: 2, index3: 1)
    let result = bori(before, instruction: instruction)
    print(result)
    print(result == after)
}

let test1 = """
Before: [3, 2, 1, 1]
9 2 1 2
After:  [3, 2, 2, 1]
"""

parseInput(test1)
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

