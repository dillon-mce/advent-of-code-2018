import Foundation

func produceCheckSum(on string: String) -> Int {
    var array = string.components(separatedBy: .whitespacesAndNewlines)
    let contains2 = array.filter() { containsMultiples($0, count: 2) }.count
    let contains3 = array.filter() { containsMultiples($0, count: 3) }.count
    
    return contains2 * contains3
    
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
produceCheckSum(on: test1)

produceCheckSum(on: day2Input)

