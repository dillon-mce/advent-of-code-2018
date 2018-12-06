import Foundation

func matchAllButOne(_ string: String) -> [String] {
    let array = string.components(separatedBy: .whitespacesAndNewlines)
    for string1 in array {
        let filtered = array.filter() { filterString(string1, $0) }
        if filtered.count > 1 { return filtered }
    }
    return []
}

func filterString(_ string1: String, _ string2: String) -> Bool {
    var mismatches = 0
    let array1 = Array(string1)
    let array2 = Array(string2)
    for i in 0..<string1.count {
        if array1[i] != array2[i] { mismatches += 1 }
    }
    return mismatches < 2
}

func answerPart2(_ string: String) -> String {
    let array = matchAllButOne(string)
    var string = ""
    
    let array1 = Array(array[0])
    let array2 = Array(array[1])
    for i in 0..<array1.count {
        if array1[i] == array2[i] { string += String(array1[i]) }
    }
    
    return string
}

let test1 = "abcde fghij klmno pqrst fguij axcye wvxyz"

answerPart2(day2Input)
