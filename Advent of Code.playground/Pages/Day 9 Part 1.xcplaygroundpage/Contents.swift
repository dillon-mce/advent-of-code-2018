import Foundation

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

func calculateHighScore(_ string: String) -> Int {
    var input = string.components(separatedBy: .whitespaces).compactMap() { Int($0) }
    var currentMarble = Marble(score: 0)
    var scores: [Int: Int] = [:]
    let numOfPlayers = input[0]
    let rounds = input[1]
    
    for i in 1...rounds {
        let newMarble = Marble(score: i)
        if i % 23 == 0 {
            let currentPlayer = i % numOfPlayers != 0 ? i % numOfPlayers : numOfPlayers
            var score = i
            let marbleToRemove = currentMarble.offset(-7)
            score += marbleToRemove.score
            currentMarble = marbleToRemove.nextMarble!
            marbleToRemove.remove()
            scores[currentPlayer, default: 0] += score
        } else {
            newMarble.insert(between: currentMarble.offset(1), and: currentMarble.offset(2))
            currentMarble = newMarble
        }
    }
    
    guard let winner = scores.max(by: { $0.value < $1.value }) else { return -1 }
    print("Player \(winner.key) won with a score of \(winner.value)")
    return winner.value
}

let testInput1 = "9 players; last marble is worth 25 points" // 32
calculateHighScore(testInput1)
let testInput2 = "10 players; last marble is worth 1618 points" //8317
//calculateHighScore(testInput2)
let testInput3 = "13 players; last marble is worth 7999 points" //146373
//calculateHighScore(testInput3)

calculateHighScore(day9Input)

//Answer: 410375
