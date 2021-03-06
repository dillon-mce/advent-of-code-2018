import Foundation

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
    
    var tasksRemaining: Int {
        return queue.count
    }
    
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
    let array = string.components(separatedBy: CharacterSet(charactersIn: "\n"))
    var dependencyDict: [String: [String]] = [:]
    var letterArray: [String] = []
    var letterSet: Set<String> = Set()
    let letterValueDict = setupLetterValueDictionary(timeAddition)
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
    var queues: [Queue<String>] = []
    for i in 0..<numOfWorkers {
        queues.append(Queue())
    }
    print("Letters to complete: \(letterArray), count: \(letterArray.count)")
    var completedSet: Set<String> = Set()
    var currentlyWorkingOn: Set<String> = Set()
    var results: [String] = []
    var result: Int = 0
    while letterArray.count > 0 {
        for queue in queues {
            let previouslyWorking = queue.currentlyWorkingOn
            queue.pop()
            if previouslyWorking != queue.currentlyWorkingOn {
                if let previouslyWorking = previouslyWorking {
                    completedSet.insert(previouslyWorking)
                    results.append(previouslyWorking)
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
    
    print("Answer: \(result)")
    print("Final order: \(results.joined())")
    return result
}

let testInput = """
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
"""

figureTimeWithMultipleWorkers(testInput, timeAddition: 0, numOfWorkers: 2)
figureTimeWithMultipleWorkers(day7Input, timeAddition: 60, numOfWorkers: 5)
