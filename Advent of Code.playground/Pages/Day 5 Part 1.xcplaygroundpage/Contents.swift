import Foundation

func collapsePolymer(_ string: String) -> String {
    var array = Array(string)
    print(array.count)
    var madeFullPass = false
    var madeToIndex = 0
    
    while !madeFullPass {
        var lettersToRemove: [Int] = []
        
        //print(array)
        for i in madeToIndex..<array.count - 1 {
           // print("In for loop at index \(i)")
            let firstLetter = String(array[i])
            let secondLetter = String(array[i+1])
            //print("First letter: \(firstLetter), second letter: \(secondLetter)")
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

let testInput = "dabAcCaCBAcCcaDA"
print(collapsePolymer(testInput).count)


let answer = collapsePolymer(day5input)
print(answer.count)
