#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 14"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
func calculateRecipeScoresAfter(_ int: Int) -> [Int] {
    var scores: [Int] = [3, 7]
    var elf1: Int = 0
    var elf2: Int = 1
    while scores.count < int + 12 {
        //print(scores)
        let newscore = String(scores[elf1] + scores[elf2])
        for character in newscore {
            scores.append(Int(String(character))!)
        }
        elf1 = ((elf1 + scores[elf1] + 1) % scores.count)
        elf2 = ((elf2 + scores[elf2] + 1) % scores.count)
    }
    let answer = Array(scores[int..<int+10])
    return answer
}

let test1 = 9
let test2 = 2018
assert(calculateRecipeScoresAfter(test1) == [5, 1, 5, 8, 9, 1, 6, 7, 7, 9])
assert(calculateRecipeScoresAfter(test2) == [5, 9, 4, 1, 4, 2, 9, 8, 8, 2])

// Part 2
func makeArray(_ int: Int) -> [Int] {
    let string = String(int)
    var array: [Int] = []
    for character in string {
        array.append(Int(String(character))!)
    }
    return array
}

func calculateRecipesBefore(_ int: Int) -> Int {
    var scores: [Int] = [3, 7]
    var elf1: Int = 0
    var elf2: Int = 1
    var target = makeArray(int)
    var recipesToLeft: Int?
    var count = 0
    while recipesToLeft == nil {
        count += 1
        //print(scores)
        let newScore = makeArray(scores[elf1] + scores[elf2])
        scores += newScore
        if scores.count > target.count {
            let index = scores.count-(target.count)
            let check = Array(scores[index...scores.count-1])
            //print("check: \(check), target: \(target)")
            if check == target {
                recipesToLeft = index
            } else {
                let index = scores.count-(target.count + 1)
                let check = Array(scores[index...scores.count-2])
                if check == target {
                    recipesToLeft = index
                }
            }
        }
        elf1 = ((elf1 + scores[elf1] + 1) % scores.count)
        elf2 = ((elf2 + scores[elf2] + 1) % scores.count)
        
        if count % 1000000 == 0 {
            print("\(count) times through the loop.")
        }
    }
    print(recipesToLeft!)
    return recipesToLeft!
}


assert(calculateRecipesBefore(59414) == 2018)

func findAnswers(_ string: String) {
//    var string = string
//    if string.isEmpty { string = test1 }
    
    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = calculateRecipeScoresAfter(236021)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
    
//    if string == test1 { string = test2 }
    
    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = calculateRecipesBefore(236021)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}


findAnswers(input)

