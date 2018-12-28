#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 7"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
func parseInput(_ string: String) -> ([String: [String]], [String]) {
    let array = string.components(separatedBy: .newlines)
    var dependencyDict: [String: [String]] = [:]
    var letterSet: Set<String> = Set()
    for line in array {
        let letters = line.components(separatedBy: .whitespaces).filter() { $0.count == 1 }
        dependencyDict[letters[1], default: []].append(letters[0])
        letterSet.insert(letters[0])
        letterSet.insert(letters[1])
    }
    let letterArray = Array(letterSet).sorted()
    return (dependencyDict, letterArray)
}

func figureOutOrder(_ string: String) -> String {
    var (dependencyDict, letterArray) = parseInput(string)
    
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
func setupLetterValueDictionary(_ offset: Int) -> [String: Int] {
    let alphabet = "abcdefghijklmnopqrstuvwxyz".uppercased()
    var value = 1 + offset
    var result: [String: Int] = [:]
    for letter in alphabet {
        result[String(letter)] = value
        value += 1
    }
    return result
}

class Queue<T> {
    private var queue: [T] = []
    
//    var tasksRemaining: Int {
//        return queue.count
//    }
    
    var currentlyWorkingOn: T? {
        return queue.first
    }
    
    func push(_ string: T, times: Int) {
        for _ in 0..<times {
            queue.append(string)
        }
    }
    
    func pop() {
        if queue.count > 0 {
            queue.remove(at: 0)
        }
    }
}

func figureTimeWithMultipleWorkers(_ string: String, timeAddition: Int, numOfWorkers: Int) -> Int {
    var (dependencyDict, letterArray) = parseInput(string)
    let letterValueDict = setupLetterValueDictionary(timeAddition)
    var queues: [Queue<String>] = []
    for _ in 0..<numOfWorkers {
        queues.append(Queue())
    }
    var completedSet: Set<String> = Set()
    var currentlyWorkingOn: Set<String> = Set()
    var result: Int = 0
    while letterArray.count > 0 {
        for queue in queues {
            let previouslyWorking = queue.currentlyWorkingOn
            queue.pop()
            if previouslyWorking != queue.currentlyWorkingOn {
                if let previouslyWorking = previouslyWorking {
                    completedSet.insert(previouslyWorking)
                }
            }
        }
        letterArray = letterArray.filter() { !completedSet.contains( $0 ) }
        if letterArray.count == 0 { break }
        for letter in letterArray {
            let dependencies = dependencyDict[letter]?.filter() { !completedSet.contains( $0 ) }
            if (dependencies == nil || dependencies == []) && !currentlyWorkingOn.contains(letter) {
                for queue in queues {
                    if queue.currentlyWorkingOn == nil {
                        let times = letterValueDict[letter] ?? 0
                        queue.push(letter, times: times)
                        currentlyWorkingOn.insert(letter)
                        break
                    }
                }
            }
        }
        result += 1
    }
    return result
}

let test2 = test1
assert(figureTimeWithMultipleWorkers(test2, timeAddition: 0, numOfWorkers: 2) == 15)

func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }

    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = figureOutOrder(string)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")

    if string == test1 { string = test2 }

    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = figureTimeWithMultipleWorkers(string, timeAddition: 60, numOfWorkers: 5)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}


findAnswers(input)


