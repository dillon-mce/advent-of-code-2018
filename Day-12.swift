#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY "
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
class Pot {
    var nextPot: Pot? = nil
    var previousPot: Pot? = nil
    
    let index: Int
    var hasPlant: Bool
    
    init (index: Int, hasPlant: Bool = false) {
        self.index = index
        self.hasPlant = hasPlant
    }
    
    func addToRight(of pot: Pot) {
        self.previousPot = pot
        pot.nextPot = self
    }
    
    func addToLeft(of pot: Pot) {
        self.nextPot = pot
        pot.previousPot = self
    }
    
    func remove() {
        previousPot?.nextPot = nil
        nextPot?.previousPot = nil
        self.nextPot = nil
        self.previousPot = nil
    }
    
    func pot(offset: Int) -> Pot {
        var pot: Pot = self
        for _ in 0..<offset.magnitude {
            if offset > 0 {
                if pot.nextPot == nil {
                    let newPot = Pot(index: pot.index + 1)
                    newPot.addToRight(of: pot)
                    pot = newPot
                } else {
                    pot = pot.nextPot!
                }
            } else {
                if pot.previousPot == nil {
                    let newPot = Pot(index: pot.index - 1)
                    newPot.addToLeft(of: pot)
                    pot = newPot
                } else {
                    pot = pot.previousPot!
                }
            }
        }
        return pot
    }
}

struct Rule: CustomStringConvertible {
    let farLeft: Bool
    let left: Bool
    let center: Bool
    let right: Bool
    let farRight: Bool
    
    let returns: Bool
    
    var description: String {
        return "\(farLeft ? "#" : ".")\(left ? "#" : ".")\(center ? "#" : ".")\(right ? "#" : ".")\(farRight ? "#" : ".") => \(returns ? "#" : ".")"
    }
    
    func check(_ pot: Pot) -> Bool {
        return pot.pot(offset: -2).hasPlant == farLeft &&
            pot.pot(offset: -1).hasPlant == left &&
            pot.hasPlant == center &&
            pot.pot(offset: 1).hasPlant == right &&
            pot.pot(offset: 2).hasPlant == farRight
    }
}

func parseInput(_ string: String) -> ([Pot], [Rule]) {
    var array = string.components(separatedBy: .newlines)
    let initialState = array[0].components(separatedBy: .whitespaces).last!
    var currentPot: Pot?
    var pots: [Pot] = []
    for (index, character) in initialState.enumerated() {
        let hasPlant = character == Character("#")
        let pot = Pot(index: index, hasPlant: hasPlant)

        if let currentPot = currentPot {
            pot.addToRight(of: currentPot)
        }
        pots.append(pot)
        currentPot = pot
    }
    
    var rules: [Rule] = []
    array.removeFirst(2)
    for line in array {
        let characters = Array(line)
        let hash = Character("#")
        let farLeft = characters[0] == hash
        let left = characters[1] == hash
        let center = characters[2] == hash
        let right = characters[3] == hash
        let farRight = characters[4] == hash
        let returns = characters[9] == hash
        
        let rule = Rule(farLeft: farLeft, left: left, center: center, right: right, farRight: farRight, returns: returns)
        
        rules.append(rule)
        
    }
    
    return (pots, rules)
}
func determineState(_ string: String, after generations: Int) -> Int {
    var (pots, rules) = parseInput(string)
    var string = ""
    for pot in pots {
        string += pot.hasPlant ? "#" : "."
    }
    print("0 – \(string)")
    var delta = 0
    var currentTotal = 0
    var count = 0
    var keepGoing = true
    var startTime = CFAbsoluteTimeGetCurrent()
    while keepGoing {
        count += 1
        var newValues: [Bool] = []
        if let firstPot = pots.first, let lastPot = pots.last {
            var currentPot = firstPot
            if pots[0].hasPlant || pots[1].hasPlant {
                for _ in 0..<1 {
                    let newPot = Pot(index: currentPot.index - 1, hasPlant: false)
                    newPot.addToLeft(of: currentPot)
                    currentPot = newPot
                    pots.insert(newPot, at: 0)
                }
            } else if !pots[0].hasPlant && !pots[1].hasPlant {
                pots.removeFirst().remove()
            }
            currentPot = lastPot
            if pots[pots.count - 1].hasPlant || pots[pots.count - 2].hasPlant {
                for _ in 0..<2 {
                    let newPot = Pot(index: currentPot.index + 1, hasPlant: false)
                    newPot.addToRight(of: currentPot)
                    currentPot = newPot
                    pots.append(newPot)
                }
            }
        }
        
        for pot in pots {
            for rule in rules {
                if rule.check(pot) {
                    //print("pot \(pot.index) passed the rule \(rule), setting it's value to \(rule.returns))")
                    newValues.append(rule.returns)
                    break
                }
            }
        }
        
        string = ""
        for (pot, value) in zip(pots, newValues) {
            pot.hasPlant = value
            string += pot.hasPlant ? "#" : "."
        }
        let total = pots.reduce(0) { $0 + ($1.hasPlant ? $1.index : 0) }
        let newDelta = total - currentTotal
        print("\(count): Total of \(total), minus \(currentTotal) for a delta of \(newDelta)")
        currentTotal = total
        if newDelta == delta {
            keepGoing = false
            break
        }
        delta = newDelta
//        if i % (generations / 10) == 0 {
//            print("\(i) – \(string)")
//            print("\(CFAbsoluteTimeGetCurrent() - startTime) seconds since last round")
//            let total = pots.reduce(0) { $0 + ($1.hasPlant ? $1.index : 0) }
//            print("Total of \(total), for a delta of \(total - delta)")
//            delta = total
//            startTime = CFAbsoluteTimeGetCurrent()
//        }
    }
    var result = currentTotal + ((50000000000 - (count)) * delta)
    return result
}

let test1 = """
initial state: #......##...#.#.###.#.##..##.#.....##....#.#.##.##.#..#.##........####.###.###.##..#....#...###.##

.#.## => .
.#### => .
#..#. => .
##.## => #
..##. => #
##... => #
..#.. => #
#.##. => .
##.#. => .
.###. => #
.#.#. => #
#..## => #
.##.# => #
#.### => #
.##.. => #
###.# => .
#.#.# => #
#.... => .
#...# => .
.#... => #
##..# => .
....# => .
..... => .
.#..# => #
##### => .
#.#.. => .
..#.# => #
...## => .
...#. => #
..### => .
####. => #
###.. => #
"""
print(determineState(test1, after: 10000))
//assert(produceCheckSum(on: test1) == 12)

// Part 2


let test2 = ""
//assert(answerPart2(test2) == "")

//func findAnswers(_ string: String) {
//    var string = string
//    if string.isEmpty { string = test1 }
//
//    var startTime = CFAbsoluteTimeGetCurrent()
//    // update function here
//    let answer1 = produceCheckSum(on: string)
//    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
//
//    if string == test1 { string = test2 }
//
//    startTime = CFAbsoluteTimeGetCurrent()
//    // update function here
//    let answer2 = answerPart2(string)
//    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
//}
//
//
////findAnswers(input)


