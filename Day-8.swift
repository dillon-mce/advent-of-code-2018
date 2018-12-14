#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 8"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
class Node {
    var children: [Node] = []
    var metadata: [Int] = []
    
    var sumOfMetadata: Int {
        var metadataSum = metadata.reduce(0, +)
        for child in children {
            metadataSum += child.sumOfMetadata
        }
        
        return metadataSum
    }
    
    var sumOfMetadata2: Int {
        var metadataSum = 0
        if children.count == 0 {
            return metadata.reduce(0, +)
        } else {
            for item in metadata {
                if item - 1 < children.count {
                    metadataSum += children[item-1].sumOfMetadata2
                }
            }
            return metadataSum
        }
    }
    
    init (children: [Node], metadata: [Int]) {
        self.children = children
        self.metadata = metadata
    }
}

func produceNodes(_ array: inout [Int]) -> Node {
    let childrenCount = array.removeFirst()
    let metadataCount = array.removeFirst()
    
    var children: [Node] = []
    var metadata: [Int] = []
    for _ in 0..<childrenCount {
        let child = produceNodes(&array)
        children.append(child)
    }
    for _ in 0..<metadataCount {
        metadata.append(array.removeFirst())
    }
    
    return Node(children: children, metadata: metadata)
}

func calculateSum (_ string: String) -> Int {
    let array = string.components(separatedBy: .whitespaces).compactMap() { Int($0) }
    var mutableArray = array
    
    let node = produceNodes(&mutableArray)
    // print("Node has \(node.children.count) children and the metadata values: \(node.metadata). The sum of all the metadata is \(node.sumOfMetadata)")
    
    
    return node.sumOfMetadata
}

let test1 = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
assert(calculateSum(test1) == 138)

// Part 2
func calculateSum2 (_ string: String) -> Int {
    let array = string.components(separatedBy: .whitespaces).compactMap() { Int($0) }
    var mutableArray = array
    
    let node = produceNodes(&mutableArray)
    //print("Node has \(node.children.count) children and the metadata values: \(node.metadata). The sum of all the metadata is \(node.sumOfMetadata2)")
    
    
    return node.sumOfMetadata2
}

let test2 = test1
assert(calculateSum2(test2) == 66)

func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }

    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = calculateSum(string)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")

    if string == test1 { string = test2 }

    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = calculateSum2(string)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}


findAnswers(input)


