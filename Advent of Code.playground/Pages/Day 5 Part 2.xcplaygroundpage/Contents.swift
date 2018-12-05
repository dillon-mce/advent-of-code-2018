import Foundation

func collapsePolymer(_ string: String) -> String {
    var array = Array(string)
    var madeFullPass = false
    var madeToIndex = 0
    
    while !madeFullPass {
        for i in madeToIndex..<array.count - 1 {
            let firstLetter = String(array[i])
            let secondLetter = String(array[i+1])
            if firstLetter.lowercased() == secondLetter.lowercased() && firstLetter != secondLetter {
                array.remove(at: i)
                array.remove(at: i)
                madeToIndex = i > 1 ? i - 2 : 0
                break
            } else if i == array.count-2 {
                madeFullPass = true
            }
        }
    }
    
    return String(array)
    
}

func testWithoutCertainLetters(_ string: String) -> String {
    let letters = Set(Array(string.lowercased()))
    print(letters)
    var resultsDict: [Character: String] = [:]
    
    for letter in letters {
        let array = Array(string).filter() { String($0).lowercased() != String(letter) }
        let result = collapsePolymer(String(array))
        resultsDict[letter] = result
        print("Without \(letter) the count is: \(result.count)")
    }
    
    let answer = resultsDict.min(by: { $0.value.count < $1.value.count })
    return answer?.value ?? "Didn't produce a result."
}



let testInput = "dabAcCaCBAcCcaDA"
testWithoutCertainLetters(testInput)

let answer = testWithoutCertainLetters(day5input)
print(answer.count)
