#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 15"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
struct Point: Hashable, Comparable, CustomStringConvertible {
    var x: Int
    var y: Int
    
    static func < (lhs: Point, rhs: Point) -> Bool {
        if lhs.y == rhs.y {
            return lhs.x < rhs.x
        } else {
            return lhs.y < rhs.y
        }
    }
    
    var description: String {
        return "P(\(x), \(y))"
    }
    
    var above: Point {
        return Point(x: x, y: y - 1)
    }
    var below: Point {
        return Point(x: x, y: y + 1)
    }
    var left: Point {
        return Point(x: x - 1, y: y)
    }
    var right: Point {
        return Point(x: x + 1, y: y)
    }
    
    var neighbors: [Point] {
        return [above, below, left, right]
    }
    
    func allReachablePoints(on gameBoard: GameBoard, distance: Int = 0) -> Set<Point> {
        let newDistance = distance + 1
        var allReachablePoints = Set<Point>()
        let spaceAbove = gameBoard.map[above]
        if spaceAbove == .open && gameBoard.players[above] == nil {
            if gameBoard.distances[above] == nil || newDistance < gameBoard.distances[above]! {
                gameBoard.distances[above] = newDistance
                allReachablePoints.insert(above)
                gameBoard.map[above] = .marked
            }
            allReachablePoints = allReachablePoints.union(above.allReachablePoints(on: gameBoard, distance: newDistance))
            
        }
        if gameBoard.map[below] == .open && gameBoard.players[below] == nil {
            allReachablePoints.insert(below)
            gameBoard.map[below] = .marked
            allReachablePoints = allReachablePoints.union(below.allReachablePoints(on: gameBoard, distance: newDistance))
        }
        if gameBoard.map[left] == .open && gameBoard.players[left] == nil {
            allReachablePoints.insert(left)
            gameBoard.map[left] = .marked
            allReachablePoints = allReachablePoints.union(left.allReachablePoints(on: gameBoard, distance: newDistance))
        }
        if gameBoard.map[right] == .open && gameBoard.players[right] == nil {
            allReachablePoints.insert(right)
            gameBoard.map[right] = .marked
            allReachablePoints = allReachablePoints.union(right.allReachablePoints(on: gameBoard, distance: newDistance))
        }
        
        return allReachablePoints
    }
    
    func distanceFrom(_ point: Point) -> Int {
        return abs(self.x - point.x) + abs(self.y - point.y)
    }
}

struct Queue<T> {
    var array: [T] = []
    
    var isEmpty: Bool {
        return count == 0
    }
    
    var count: Int {
        return array.count
    }
    
    mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    mutating func dequeue() -> T? {
        return isEmpty ? nil : array.removeFirst()
    }
    
    var first: T? {
        return array.first
    }
}


enum Team: String {
    case elf = "E"
    case goblin = "G"
}

class Player: CustomStringConvertible {
    var location: Point
    var health: Int = 300
    let attackPower: Int = 3
    let team: Team
    var otherPlayers: [Point: Player] = [:]
    var enemies: [Point: Player] = [:]
    
    var description: String {
        return "\(team.rawValue.capitalized)"
    }
    
    init(location: Point, team: Team) {
        self.location = location
        self.team = team
    }
    
    func takeTurn(_ gameBoard: GameBoard) -> Bool {
        // Get a reference to the other players
        otherPlayers = gameBoard.players
        otherPlayers[self.location] = nil
        
        // Figure out who the enemies are
        scanForTargets()
        if enemies.count == 0 {
            return false
        }
        
        // Calculate which points are in rage
        var pointsInRange = Set<Point>()
        for point in enemies.keys {
            pointsInRange = pointsInRange.union(calculateInRange(point, gameBoard: gameBoard))
        }
        
        let allReachablePoints = location.allReachablePoints(on: gameBoard)
        let reachablePoints = allReachablePoints.intersection(pointsInRange)
        //print(reachablePoints)
        
        var distance = 0
        var queue: Queue<Point> = Queue()
        queue.enqueue(location)
        gameBoard.distances[location] = distance
        
        // Reset the gameboard
        for point in allReachablePoints {
            gameBoard.map[point] = .open
        }
        
        // Figure out the distances to each reachable point
        while let point = queue.dequeue() {
            //print("Dequeued point: \(point).\nIt's neighbors are: \(point.neighbors)")
            for neighboringPoint in point.neighbors {
                if gameBoard.map[neighboringPoint] == .open && (gameBoard.distances[neighboringPoint] == nil || gameBoard.distances[point]! + 1 < gameBoard.distances[neighboringPoint]!) {
                    queue.enqueue(neighboringPoint)
                    gameBoard.distances[neighboringPoint] = gameBoard.distances[point, default: 0] + 1
                }
            }
        }
        
        let reachableDistances = gameBoard.distances.filter({ reachablePoints.contains( $0.key ) })
        print(reachableDistances)
        
        guard let minValue = reachableDistances.min(by: { $0.value < $1.value }) else {
            print("This player doesn't have any closest points to target.")
            return true
        }
        
        let nearestDistances = reachableDistances.filter { $0.value == minValue.value }
        
        let chosen = nearestDistances.min(by: { $0.key < $1.key })!
        print(chosen)
        
        gameBoard.distances = [:]
        
        return true
    }
    
    func scanForTargets(){
        enemies = otherPlayers.filter() { $0.value.team != self.team }
    }
    
    func calculateInRange(_ point: Point, gameBoard: GameBoard) -> Set<Point> {
        var pointsInRange = Set<Point>()
        let above = point.above
        if gameBoard.map[above] == .open && otherPlayers[above] == nil {
            pointsInRange.insert(above)
        }
        let below = point.below
        if gameBoard.map[below] == .open && otherPlayers[below] == nil {
            pointsInRange.insert(below)
        }
        let left = point.left
        if gameBoard.map[left] == .open && otherPlayers[left] == nil {
            pointsInRange.insert(left)
        }
        let right = point.right
        if gameBoard.map[right] == .open && otherPlayers[right] == nil {
            pointsInRange.insert(right)
        }
        
        return pointsInRange
    }
    
}

enum SpaceType: CustomStringConvertible, Equatable {
    case wall
    case open
    case marked

    var label: String {
        switch self {
        case .wall:
            return "#"
        case .open:
            return "."
        case .marked:
            return "X"
        }
    }
    
    static func ==(lhs: SpaceType, rhs: SpaceType) -> Bool {
        switch (lhs, rhs) {
        case (.wall, .wall), (.open, .open), (.marked, .marked):
            return true
        default:
            return false
        }
    }
    
    var description: String {
        return "\(label)"
    }
}

class GameBoard {
    var map: [Point: SpaceType]
    var players: [Point: Player]
    var distances: [Point: Int] = [:]
    
    init (map: [Point: SpaceType], players: [Point: Player]) {
        self.map = map
        self.players = players
    }
}

func parseInput(_ string: String) -> GameBoard {
    let array = string.components(separatedBy: .newlines)
    var map: [Point: SpaceType] = [:]
    var players: [Point: Player] = [:]
    let playerMarkers = Set<Character>(arrayLiteral: "E", "G")
    
    for y in 0..<array.count {
        let line = Array(array[y])
        for x in 0..<line.count {
            let point = Point(x: x, y: y)
            let character = line[x]
            map[point] = character == "#" ? .wall : .open
            
            if playerMarkers.contains(character) {
                let team: Team = character == "E" ? .elf : .goblin
                players[point] = Player(location: point, team: team)
            }
        }
    }
    let gameBoard = GameBoard(map: map, players: players)
    return gameBoard
}

func printMap(_ gameBoard: GameBoard) {
    let map = gameBoard.map
    let players = gameBoard.players
    guard let maxX = map.max(by: { $0.key.x < $1.key.x }),
        let maxY = map.max(by: { $0.key.y < $1.key.y }) else { return }
    for y in 0...maxY.key.y {
        var line = ""
        for x in 0...maxX.key.x {
            let point = Point(x: x, y: y)
            if let player = players[point] {
                line += "\(player)"
            } else if let space = map[point] {
                line += "\(space)"
            }
        }
        print(line)
    }
}

func figureOutResultOfBattle(_ string: String) -> Int {
    var result = 0
    let gameBoard = parseInput(string)
    
    printMap(gameBoard)
    for (_, player) in gameBoard.players.sorted(by: { $0.key < $1.key }) {
        player.takeTurn(gameBoard)
    }
    
    
    return result
}


let test1 = """
#########
#G..G..G#
#.......#
#.......#
#G..E..G#
#.......#
#.......#
#G..G..G#
#########
"""

let test2 = """
#######
#E..G.#
#...#.#
#.G.#G#
#######
"""

figureOutResultOfBattle(test2)
//print(players.sorted(by: { $0.key < $1.key }))
//assert(produceCheckSum(on: test1) == 12)

// Part 2


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


//findAnswers(input)

