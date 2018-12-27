#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 6"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
struct Point: Hashable {
    var x: Int
    var y: Int
    
    func calculateDistance(from point: Point) -> Int {
        return abs(self.x - point.x) + abs(self.y - point.y)
    }
}

func parseInput(_ string: String) -> [Point] {
    let array = string.components(separatedBy: CharacterSet(charactersIn: "\n"))
    
    let pointArray = array.compactMap() { string -> Point? in
        let array = string.components(separatedBy: .punctuationCharacters).joined().components(separatedBy: .whitespaces)
        guard array.count > 1, let x = Int(array[0]), let y = Int(array[1]) else { return nil }
        let point = Point(x: x, y: y)
        return point
    }
    
    return pointArray
}

func calculateLargestArea(_ string: String) -> Int {
    let pointArray = parseInput(string)
    
    guard let maxX = pointArray.max(by: { $0.x < $1.x }), let maxY = pointArray.max(by: { $0.y < $1.y }), let minX = pointArray.min(by: { $0.x < $1.x }), let minY = pointArray.min(by: { $0.y < $1.y }) else { return -1 }
    
    var areaDict: [Point: [Point]] = [:]
    for x in minX.x...maxX.x {
        for y in minY.y...maxY.y {
            var distanceDict: [Point: Int] = [:]
            let testPoint = Point(x: x, y: y)
            for point in pointArray {
                distanceDict[point] = point.calculateDistance(from: testPoint)
            }
            if let min = distanceDict.min(by: { $0.value < $1.value }) {
                if distanceDict.values.filter({ $0 == min.value }).count == 1 {
                    areaDict[min.key, default: []].append(testPoint)
                }
            }
        }
    }
    
    let filteredDict = areaDict.filter { (key: Point, value: [Point]) -> Bool in
        let array = value.filter() {
            return $0.x == minX.x || $0.x == maxX.x || $0.y == minY.y || $0.y == maxY.y
        }
        return !(array.count > 0)
    }
    
    let biggestArea = filteredDict.max(by: { $0.value.count < $1.value.count })
    
    return biggestArea?.value.count ?? -1
}

let test1 = """
1, 1
1, 6
8, 3
3, 4
5, 5
8, 9
"""
assert(calculateLargestArea(test1) == 17)

// Part 2
func calculateLargestArea(_ string: String, targetValue: Int) -> Int {
    let pointArray = parseInput(string)
    
    guard let maxX = pointArray.max(by: { $0.x < $1.x }), let maxY = pointArray.max(by: { $0.y < $1.y }), let minX = pointArray.min(by: { $0.x < $1.x }), let minY = pointArray.min(by: { $0.y < $1.y }) else { return -1 }
    
    var safePoints: Set<Point> = Set()
    for x in minX.x...maxX.x {
        for y in minY.y...maxY.y {
            var distanceDict: [Point: Int] = [:]
            let testPoint = Point(x: x, y: y)
            for point in pointArray {
                distanceDict[point] = point.calculateDistance(from: testPoint)
            }
            let sum = distanceDict.values.reduce(0, +)
            if sum < targetValue {
                safePoints.insert(testPoint)
            }
        }
    }
    
    return safePoints.count
}

let test2 = test1
assert(calculateLargestArea(test2, targetValue: 32) == 16)

func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }

    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = calculateLargestArea(string)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")

    var targetValue = 10000
    if string == test1 {
        string = test2
        targetValue = 32
    }

    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = calculateLargestArea(string, targetValue: targetValue)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}


findAnswers(input)


