#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 9"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1 & 2
class Marble {
    var score: Int
    
    var previousMarble: Marble?
    var nextMarble: Marble?
    
    init (score: Int) {
        self.score = score
        self.nextMarble = self
        self.previousMarble = self
    }
    
    func insert(between left: Marble, and right: Marble) {
        left.nextMarble = self
        self.previousMarble = left
        right.previousMarble = self
        self.nextMarble = right
    }
    
    func remove() {
        previousMarble?.nextMarble = self.nextMarble
        nextMarble?.previousMarble = self.previousMarble
    }
    
    func offset(_ offset: Int) -> Marble {
        var result = self
        for _ in 0..<offset.magnitude {
            result = offset > 0 ? result.nextMarble! : result.previousMarble!
        }
        return result
    }
}

func calculateHighScore(_ string: String, multiplier: Int) -> Int {
    var input = string.components(separatedBy: .whitespaces).compactMap() { Int($0) }
    var currentMarble = Marble(score: 0)
    var scores: [Int: Int] = [:]
    let numOfPlayers = input[0]
    let rounds = input[1] * multiplier
    
    for i in 1...rounds {
        if i % 23 == 0 {
            let currentPlayer = i % numOfPlayers != 0 ? i % numOfPlayers : numOfPlayers
            var score = i
            let marbleToRemove = currentMarble.offset(-7)
            score += marbleToRemove.score
            currentMarble = marbleToRemove.nextMarble!
            marbleToRemove.remove()
            scores[currentPlayer, default: 0] += score
        } else {
            let newMarble = Marble(score: i)
            newMarble.insert(between: currentMarble.offset(1), and: currentMarble.offset(2))
            currentMarble = newMarble
        }
    }
    
    //    for (player, score) in scores.sorted(by: { $0.key < $1.key }) {
    //        //print("Player \(player) got a score of: \(score)")
    //    }
    
    guard let winner = scores.max(by: { $0.value < $1.value }) else { return -1 }
    //print("Player \(winner.key) won with a score of \(winner.value)")
    return winner.value
}

let test1 = "10 players; last marble is worth 1618 points"

assert(calculateHighScore(test1, multiplier: 1) == 8317)

// Part 2

let test2 = test1
assert(calculateHighScore(test2, multiplier: 100) == 74765078)

func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }

    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = calculateHighScore(string, multiplier: 1)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")

    if string == test1 { string = test2 }

    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = calculateHighScore(string, multiplier: 100)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}


findAnswers(input)


