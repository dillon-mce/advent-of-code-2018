#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 13"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
struct Point: Hashable, Comparable {
    var x: Int
    var y: Int
    
    static func < (lhs: Point, rhs: Point) -> Bool {
        if lhs.y == rhs.y {
            return lhs.x < rhs.x
        } else {
            return lhs.y < rhs.y
        }
    }
}

enum Track {
    case vertical
    case horizontal
    case intersection
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case empty
}

class Cart {
    static var cartCount = 0
    
    var direction: Direction
    var intersections: Int = 0
    let index: Int
    
    init (direction: Direction) {
        self.direction = direction
        Cart.cartCount += 1
        self.index = Cart.cartCount
    }
    
    func turnLeft() -> Direction {
        switch self.direction {
        case .up:
            return .left
        case .left:
            return .down
        case .down:
            return .right
        case .right:
            return .up
        }
    }
    
    func turnRight() -> Direction {
        switch self.direction {
        case .up:
            return .right
        case .right:
            return .down
        case .down:
            return .left
        case .left:
            return .up
        }
    }
}

enum Direction {
    case up, down, left, right
}

func parseInput(_ string: String) -> ([Point : Track], [Point: Cart]) {
    var trackDict: [Point : Track] = [:]
    var cartDict: [Point: Cart] = [:]
    let array = string.components(separatedBy: .newlines)
    for y in 0..<array.count {
        let line = Array(array[y])
        for x in 0..<line.count {
            let element = line[x]
            var track: Track = .empty
            let point = Point(x: x, y: y)
            let characterSet: Set<Character> = Set(arrayLiteral: "+", "-")
            switch element {
            case "|":
                track = Track.vertical
            case "-":
                track = .horizontal
            case "+":
                track = .intersection
            case "\\":
                if x > 0 {
                    let previousElement = line[x - 1]
                    if characterSet.contains(previousElement) {
                        track = .topRight
                    } else {
                        track = .bottomLeft
                    }
                } else {
                    let nextElement = line[x + 1]
                    if characterSet.contains(nextElement) {
                        track = .bottomLeft
                    } else {
                        track = .topRight
                    }
                }
            case "/":
                if x > 0 {
                    let previousElement = line[x - 1]
                    if characterSet.contains(previousElement) {
                        track = .bottomRight
                    } else {
                        track = .topLeft
                    }
                } else {
                    let nextElement = line[x + 1]
                    if characterSet.contains(nextElement) {
                        track = .topLeft
                    } else {
                        track = .bottomRight
                    }
                }
            case "<":
                track = .horizontal
                cartDict[point] = Cart(direction: .left)
            case ">":
                track = .horizontal
                cartDict[point] = Cart(direction: .right)
            case "^":
                track = .vertical
                cartDict[point] = Cart(direction: .up)
            case "v":
                track = .vertical
                cartDict[point] = Cart(direction: .down)
            default:
                break
            }
            if track != .empty { trackDict[point] = track }
        }
    }
    return (trackDict, cartDict)
}

func findFirstCrash(_ string: String) -> Point {
    var (trackDict, cartDict) = parseInput(string)
    var firstCrash: Point?
    var count = 0
    //print(cartDict.sorted(by: { $0.key < $1.key }))
    while firstCrash == nil {
        count += 1
        let keys = cartDict.keys.sorted()
        for key in keys {
            guard let cart = cartDict[key] else {
                print("Couldn't get a reference to the cart for some reason.")
                continue
            }
            let newPoint: Point
            switch cart.direction {
            case .up:
                newPoint = Point(x: key.x, y: key.y - 1)
            case .down:
                newPoint = Point(x: key.x, y: key.y + 1)
            case .left:
                newPoint = Point(x: key.x - 1, y: key.y)
            case .right:
                newPoint = Point(x: key.x + 1, y: key.y)
            }
            
            if cartDict[newPoint] != nil {
                firstCrash = newPoint
                break
            }
            cartDict[newPoint] = cart
            cartDict[key] = nil
            
            guard let track = trackDict[newPoint] else {
                print("\(count) - Couldn't get the track at point (\(newPoint.x), \(newPoint.y))")
                continue
            }
            
            switch track {
            case .topLeft:
                if cart.direction == .up {
                    cart.direction = .right
                } else {
                    cart.direction = .down
                }
            case .topRight:
                if cart.direction == .up {
                    cart.direction = .left
                } else {
                    cart.direction = .down
                }
            case .bottomLeft:
                if cart.direction == .down {
                    cart.direction = .right
                } else {
                    cart.direction = .up
                }
            case .bottomRight:
                if cart.direction == .down {
                    cart.direction = .left
                } else {
                    cart.direction = .up
                }
            case .intersection:
                let decider = cart.intersections % 3
                if decider == 0 {
                    cart.direction = cart.turnLeft()
                } else if decider == 2 {
                    cart.direction = cart.turnRight()
                }
                cart.intersections += 1
            default:
                break
            }
            
        }
    }
    print("\(count) times through the loop")
    return firstCrash!
}

//findFirstCrash(input)
//assert(produceCheckSum(on: test1) == 12)

// Part 2


let test2 = ""
//assert(answerPart2(test2) == "")

func findAnswers(_ string: String) {
    //var string = string
    //if string.isEmpty { string = test1 }

    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = findFirstCrash(string)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")

    //if string == test1 { string = test2 }

    startTime = CFAbsoluteTimeGetCurrent()
    // update function here
//    let answer2 = answerPart2(string)
//    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}


findAnswers(input)

