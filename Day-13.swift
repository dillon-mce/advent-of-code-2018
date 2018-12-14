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
    
    func distanceFrom(_ point: Point) -> Int {
        return abs(self.x - point.x) + abs(self.y - point.y)
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
    var currentPoint: Point
    
    init (direction: Direction, point: Point) {
        self.direction = direction
        Cart.cartCount += 1
        self.index = Cart.cartCount
        self.currentPoint = point
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

func parseInput(_ string: String) -> ([Point : Track], [Cart]) {
    var trackDict: [Point : Track] = [:]
    var cartArray: [Cart] = []
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
                cartArray.append(Cart(direction: .left, point: point))
            case ">":
                track = .horizontal
                cartArray.append(Cart(direction: .right, point: point))
            case "^":
                track = .vertical
                cartArray.append(Cart(direction: .up, point: point))
            case "v":
                track = .vertical
                cartArray.append(Cart(direction: .down, point: point))
            default:
                break
            }
            if track != .empty { trackDict[point] = track }
        }
    }
    return (trackDict, cartArray)
}

func findFirstCrash(_ string: String) -> Point {
    var (trackDict, cartArray) = parseInput(string)
    var firstCrash: Point?
    var count = 0
    var cartsAt: Set<Point> = Set()
    while firstCrash == nil {
        count += 1
        for cart in cartArray {
            let newPoint: Point
            switch cart.direction {
            case .up:
                newPoint = Point(x: cart.currentPoint.x, y: cart.currentPoint.y - 1)
            case .down:
                newPoint = Point(x: cart.currentPoint.x, y: cart.currentPoint.y + 1)
            case .left:
                newPoint = Point(x: cart.currentPoint.x - 1, y: cart.currentPoint.y)
            case .right:
                newPoint = Point(x: cart.currentPoint.x + 1, y: cart.currentPoint.y)
            }

            if cartsAt.contains(newPoint) {
                firstCrash = newPoint
                break
            }
            cartsAt.remove(cart.currentPoint)
            cart.currentPoint = newPoint
            cartsAt.insert(newPoint)
            
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
//        print("ROUND \(count)")
//        for key in cartDict.keys.sorted() {
//            let cart = cartDict[key]!
//            print("Cart \(cart.index) is at point (\(key.x), \(key.y)) and is moving \(cart.direction)")
//        }
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

