import Foundation

class Node {
    var children: [Node] = []
    var metadata: [Int] = []
    
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
    print("Node has \(node.children.count) children and the metadata values: \(node.metadata). The sum of all the metadata is \(node.sumOfMetadata)")
    
    
    return node.sumOfMetadata
}

let testInput = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
calculateSum(testInput)

calculateSum(day8Input)

// Answer: 35189
