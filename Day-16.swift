#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 16"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
var verbose = false
struct RegisterSet: CustomStringConvertible {
    var index0: Int
    var index1: Int
    var index2: Int
    var index3: Int
    
    var description: String {
        return "[\(index0), \(index1), \(index2), \(index3)]"
    }
    
    init(_ array: [Int]) {
        index0 = array[0]
        index1 = array[1]
        index2 = array[2]
        index3 = array[3]
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
let addr = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = registerSet[instruction[1]] + registerSet[instruction[2]]
    result[instruction[3]] = newValue
    if verbose { print("Calling addr on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

let addi = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = registerSet[instruction[1]] + instruction[2]
    result[instruction[3]] = newValue
    if verbose { print("Calling addi on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

// Multiply methods
let mulr = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = registerSet[instruction[1]] * registerSet[instruction[2]]
    result[instruction[3]] = newValue
    if verbose { print("Calling mulr on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

let muli = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = registerSet[instruction[1]] * instruction[2]
    result[instruction[3]] = newValue
    if verbose { print("Calling muli on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

// Bitwise methods
let banr = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = registerSet[instruction[1]] & registerSet[instruction[2]]
    result[instruction[3]] = newValue
    if verbose { print("Calling banr on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

let bani = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = registerSet[instruction[1]] & instruction[2]
    result[instruction[3]] = newValue
    if verbose { print("Calling bani on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

let borr = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = registerSet[instruction[1]] | registerSet[instruction[2]]
    result[instruction[3]] = newValue
    if verbose { print("Calling borr on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

let bori = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = registerSet[instruction[1]] | instruction[2]
    result[instruction[3]] = newValue
    if verbose { print("Calling bori on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

// Assignment methods
let setr = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = registerSet[instruction[1]]
    result[instruction[3]] = newValue
    if verbose { print("Calling setr on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

let seti = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = instruction[1]
    result[instruction[3]] = newValue
    if verbose { print("Calling seti on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

// Greater-than methods
let gtir = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = instruction[1] > registerSet[instruction[2]]
    result[instruction[3]] = newValue ? 1 : 0
    if verbose { print("Calling gtir on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

let gtri = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = registerSet[instruction[1]] > instruction[2]
    result[instruction[3]] = newValue ? 1 : 0
    if verbose { print("Calling gtri on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

let gtrr = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = registerSet[instruction[1]] > registerSet[instruction[2]]
    result[instruction[3]] = newValue ? 1 : 0
    if verbose { print("Calling gtrr on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

// Equality methods
let eqir = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = instruction[1] == registerSet[instruction[2]]
    result[instruction[3]] = newValue ? 1 : 0
    if verbose { print("Calling eqir on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

let eqri = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = registerSet[instruction[1]] == instruction[2]
    result[instruction[3]] = newValue ? 1 : 0
    if verbose { print("Calling eqri on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

let eqrr = { (_ registerSet: RegisterSet, instruction: RegisterSet) -> RegisterSet in
    var result = registerSet
    let newValue = registerSet[instruction[1]] == registerSet[instruction[2]]
    result[instruction[3]] = newValue ? 1 : 0
    if verbose { print("Calling eqrr on \(registerSet) with \(instruction) resulted in \(result)") }
    return result
}

// *0  = bori
// *1  = borr
// *2  = seti
// *3  = mulr
// *4  = setr
// *5  = addr
// *6  = gtir
// *7  = eqir
// *8  = gtri
// *9  = bani
// *10 = muli
// *11 = gtrr
// *12 = banr
// *13 = eqri
// *14 = addi
// *15 = eqrr

typealias Operation = (RegisterSet, RegisterSet) -> RegisterSet
let allOperations: [Operation] = [bori, borr, seti, mulr, setr, addr, gtir, eqir, gtri, bani, muli, gtrr, banr, eqri, addi, eqrr]

enum LineType {
    case before, after, instruction
}

func parseInput(_ string: String) -> ([[LineType: RegisterSet]], [RegisterSet]) {
    let array = string.components(separatedBy: CharacterSet(charactersIn: "-"))
    let firstArray = array[0].components(separatedBy: .newlines).filter() { $0 != "" }
    var samples: [[LineType: RegisterSet]] = []
    for i in stride(from: 0, to: firstArray.count-2, by: 3) {
        var element: [LineType: RegisterSet] = [:]
        let beforeArray = firstArray[i].components(separatedBy: .whitespaces).joined().components(separatedBy: .punctuationCharacters).compactMap() { Int($0) }
        element[.before] = RegisterSet(beforeArray)
        let instructionArray = firstArray[i+1].components(separatedBy: .whitespaces).compactMap() { Int($0) }
        element[.instruction] = RegisterSet(instructionArray)
        let afterArray = firstArray[i+2].components(separatedBy: .whitespaces).joined().components(separatedBy: .punctuationCharacters).compactMap() { Int($0) }
        element[.after] = RegisterSet(afterArray)
        samples.append(element)
    }
    
    guard array.count > 1 else { return (samples, [])}
    let secondArray = array[1].components(separatedBy: .newlines).filter() { $0 != "" }
    var program: [RegisterSet] = []
    for line in secondArray {
        let instructionArray = line.components(separatedBy: .whitespaces).compactMap() { Int($0) }
        program.append(RegisterSet(instructionArray))
    }
    
    return (samples, program)
}

func countHowManyBehaveLikeMultipleOpcodes(_ string: String, count: Int) -> Int {
    let (registerGroups, _) = parseInput(string)
    var numberOfSamples = 0
    
    for registerGroup in registerGroups {
        var matches = 0
        for operation in allOperations {
            let result = operation(registerGroup[.before]!, registerGroup[.instruction]!)
            if result == registerGroup[.after]! {
                matches += 1
            }
        }
        if matches >= count { numberOfSamples += 1 }
    }
    
    return numberOfSamples
}

let test1 = """
Before: [3, 2, 1, 1]
9 2 1 2
After:  [3, 2, 2, 1]
"""
let testBefore = RegisterSet([3, 2, 1, 1])
let testInstruction = RegisterSet([9, 2, 1, 3])

assert(addr(testBefore, testInstruction) == RegisterSet([3, 2, 1, 3]))
assert(addi(testBefore, testInstruction) == RegisterSet([3, 2, 1, 2]))
assert(mulr(testBefore, testInstruction) == RegisterSet([3, 2, 1, 2]))
assert(muli(testBefore, testInstruction) == RegisterSet([3, 2, 1, 1]))
assert(banr(testBefore, testInstruction) == RegisterSet([3, 2, 1, 0]))
assert(bani(testBefore, testInstruction) == RegisterSet([3, 2, 1, 1]))
assert(borr(testBefore, testInstruction) == RegisterSet([3, 2, 1, 3]))
assert(bori(testBefore, testInstruction) == RegisterSet([3, 2, 1, 1]))
assert(setr(testBefore, testInstruction) == RegisterSet([3, 2, 1, 1]))
assert(seti(testBefore, testInstruction) == RegisterSet([3, 2, 1, 2]))
assert(gtir(testBefore, testInstruction) == RegisterSet([3, 2, 1, 0]))
assert(gtri(testBefore, testInstruction) == RegisterSet([3, 2, 1, 0]))
assert(gtrr(testBefore, testInstruction) == RegisterSet([3, 2, 1, 0]))
assert(eqir(testBefore, testInstruction) == RegisterSet([3, 2, 1, 1]))
assert(eqri(testBefore, testInstruction) == RegisterSet([3, 2, 1, 1]))
assert(eqrr(testBefore, testInstruction) == RegisterSet([3, 2, 1, 0]))
assert(countHowManyBehaveLikeMultipleOpcodes(test1, count: 3) == 1)

let test2 = """
Before: [1, 1, 0, 3]
3 0 2 0
After:  [0, 1, 0, 3]

Before: [0, 1, 2, 3]
12 1 2 3
After:  [0, 1, 2, 0]

Before: [1, 1, 2, 0]
12 1 2 2
After:  [1, 1, 0, 0]

Before: [2, 1, 1, 1]
1 1 3 0
After:  [1, 1, 1, 1]

Before: [0, 3, 1, 2]
15 0 0 2
After:  [0, 3, 1, 2]
"""

assert(countHowManyBehaveLikeMultipleOpcodes(test2, count: 3) == 5)

// Part 2
func executeProgram(_ string: String) -> Int {
    let (_, array) = parseInput(string)
    var resultRegisterSet = RegisterSet([0, 0, 0, 0])
    
    for i in 0..<array.count {
        let opcode = array[i][0]
        let operation = allOperations[opcode]
        let result = operation(resultRegisterSet, array[i])
        resultRegisterSet = result
    }
    
    print("Resulting register set is \(resultRegisterSet)")
    return resultRegisterSet[0]
    
}

func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }
    
    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = countHowManyBehaveLikeMultipleOpcodes(string, count: 3)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
    
    if string == test1 { string = test2 }
    
    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = executeProgram(string)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}


findAnswers(input)

