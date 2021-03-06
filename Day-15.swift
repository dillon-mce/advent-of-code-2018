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
    var health: Int = 200
    let attackPower: Int
    let team: Team
    var otherPlayers: [Point: Player] = [:]
    var enemies: [Point: Player] = [:]
    
    var description: String {
        return "\(team.rawValue.capitalized)"
    }
    
    init(location: Point, team: Team, attackPower: Int = 3) {
        self.location = location
        self.team = team
        self.attackPower = attackPower
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
        
        // Move, if necessary
        if !hasAdjacentEnemies(on: gameBoard) {
            // Calculate which points are in range
            var pointsInRange = Set<Point>()
            for point in enemies.keys {
                pointsInRange = pointsInRange.union(calculateInRange(point, gameBoard: gameBoard))
            }
            
            let allReachablePoints = location.allReachablePoints(on: gameBoard)
            let reachablePoints = allReachablePoints.intersection(pointsInRange)
            
            // Reset the gameboard
            for point in allReachablePoints {
                gameBoard.map[point] = .open
            }
            findDistancesFrom(location, on: gameBoard)
            
            let reachableDistances = gameBoard.distances.filter({ reachablePoints.contains( $0.key ) })
            
            guard let minValue = reachableDistances.min(by: { $0.value < $1.value }) else {
//                print("This player doesn't have any closest points to target.")
                return true
            }
            
            let nearestDistances = reachableDistances.filter { $0.value == minValue.value }
            
            let chosen = nearestDistances.min(by: { $0.key < $1.key })!
            
            gameBoard.distances = [:]
            
            // Find the shortest routes
            findDistancesFrom(chosen.key, on: gameBoard)
            let possibleMoves = gameBoard.distances.filter({ location.neighbors.contains( $0.key ) })
            guard let shortest = possibleMoves.min(by: { $0.value < $1.value }) else { return true }
            let acceptableMoves = possibleMoves.filter() { $0.value == shortest.value }
            
            guard let move = acceptableMoves.sorted(by: {$0.key < $1.key }).first else {
                print("Couldn't find a valid move for this player.")
                return true
            }
            
            moveTo(move.key, on: gameBoard)
            gameBoard.distances = [:]
        }
        
        // Attack, if possible.
        if hasAdjacentEnemies(on: gameBoard) {
            let target = pickAttackTarget(on: gameBoard)
            attackTargetAt(target, on: gameBoard)
        }
    
        return true
    }
    
    func scanForTargets(){
        enemies = otherPlayers.filter() { $0.value.team != self.team }
    }
    
    func hasAdjacentEnemies(on gameBoard: GameBoard) -> Bool {
        for neighbor in location.neighbors {
            if enemies[neighbor] != nil {
                return true
            }
        }
        return false
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
    
    func findDistancesFrom(_ location: Point, on gameBoard: GameBoard) {
        gameBoard.distances = [:]
        var queue: Queue<Point> = Queue()
        queue.enqueue(location)
        gameBoard.distances[location] = 0
        
        // Figure out the distances to each reachable point
        while let point = queue.dequeue() {
            for neighboringPoint in point.neighbors {
                if gameBoard.map[neighboringPoint] == .open && gameBoard.players[neighboringPoint] == nil && (gameBoard.distances[neighboringPoint] == nil || gameBoard.distances[point]! + 1 < gameBoard.distances[neighboringPoint]!) {
                    queue.enqueue(neighboringPoint)
                    gameBoard.distances[neighboringPoint] = gameBoard.distances[point, default: 0] + 1
                }
            }
        }
    }
    
    func moveTo(_ point: Point, on gameBoard: GameBoard) {
        gameBoard.players[point] = self
        gameBoard.players[location] = nil
        self.location = point
    }
    
    func pickAttackTarget(on gameBoard: GameBoard) -> Point {
        var possibleTargets:  [Point: Player] = [:]
        for neighbor in location.neighbors {
            if let player = enemies[neighbor] {
                possibleTargets[player.location] = player
            }
        }
        let lowestHealth = possibleTargets.min(by: { $0.value.health < $1.value.health })!
        
        let filteredTargets = possibleTargets.filter() { $0.value.health == lowestHealth.value.health }
        
        return filteredTargets.sorted(by: { $0.key < $1.key }).first!.key
    }
    
    func attackTargetAt(_ point: Point, on gameBoard: GameBoard) {
        guard let target = gameBoard.players[point] else {
            print("There wasn't an enemy on the board at \(point)")
            return
        }
        
        target.health -= attackPower
        if target.health < 1 {
            print("An \(target.team) died at \(target.location) during round \(count)")
            gameBoard.players[point] = nil
        }
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

func parseInput(_ string: String, ap: Int = 3) -> GameBoard {
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
                let attackPower = character == "E" ? ap : 3
                players[point] = Player(location: point, team: team, attackPower: attackPower)
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

var count = 0

func figureOutResultOfBattle(_ string: String) -> Int {
    var result = 0
    let gameBoard = parseInput(string)
    var continueBattle = true
    count = 0
    
    print("\nNew Battle")
    printMap(gameBoard)
    while continueBattle {
        for key in gameBoard.players.keys.sorted(by: { $0 < $1 }) {
            if let player = gameBoard.players[key] {
                continueBattle = player.takeTurn(gameBoard)
                if !continueBattle { break }
            }
        }
        if continueBattle { count += 1 }
    }
    print("\nRound \(count)")
    printMap(gameBoard)
    
    result = gameBoard.players.values.reduce(0, { $0 + $1.health })
    print("The sum of the remaining team's health is \(result)")
    result *= count
    print("The sum of the remaining team's health times the number of rounds completed (\(count)) is \(result)")
    return result
}


let test1 = """
#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######
"""

let test2 = """
#######
#G..#E#
#E#E.E#
#G.##.#
#...#E#
#...E.#
#######
"""

let test3 = """
#######
#E..EG#
#.#G.E#
#E.##E#
#G..#.#
#..E#.#
#######
"""

let test4 = """
#########
#G......#
#.E.#...#
#..##..G#
#...##..#
#...#...#
#.G...G.#
#.....G.#
#########
"""

assert(figureOutResultOfBattle(test1) == 27730)
assert(figureOutResultOfBattle(test2) == 36334)
assert(figureOutResultOfBattle(test3) == 39514)
assert(figureOutResultOfBattle(test4) == 18740)

// Part 2
func figureOutResultOfBattleWithExtraElfPower(_ string: String) -> Int {
    var attackPower = 3
    var keepChecking = true
    var result = 0
    
    while keepChecking {
        attackPower += 1
        let gameBoard = parseInput(string, ap: attackPower)
        var continueBattle = true
        let numberOfElves = gameBoard.players.filter({ $0.value.team == .elf }).count
        count = 0
        
        print("\nNew Battle")
        printMap(gameBoard)
        while continueBattle {
            for key in gameBoard.players.keys.sorted(by: { $0 < $1 }) {
                if let player = gameBoard.players[key] {
                    continueBattle = player.takeTurn(gameBoard)
                    if !continueBattle { break }
                }
            }
            if continueBattle { count += 1 }
        }
        print("\nRound \(count)")
        printMap(gameBoard)
        
        result = gameBoard.players.values.reduce(0, { $0 + $1.health })
        print("The sum of the remaining team's health is \(result)")
        result *= count
        print("When the elves attack power is \(attackPower), the sum of the remaining team's health times the number of rounds completed (\(count)) is \(result)")
        keepChecking = gameBoard.players.filter({ $0.value.team == .elf }).count != numberOfElves
    }
    
    return result
}

assert(figureOutResultOfBattleWithExtraElfPower(test1) == 4988)


func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }
    
    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = figureOutResultOfBattle(string)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
    
    if string == test1 { string = test2 }
    
    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = figureOutResultOfBattleWithExtraElfPower(string)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}


findAnswers(input)

