import Foundation

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
    print("Letters to complete: \(letterArray)")
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
    print("Answer: \(results.joined())")
    return results.joined()
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

figureOutOrder(testInput)
figureOutOrder(day7Input)
