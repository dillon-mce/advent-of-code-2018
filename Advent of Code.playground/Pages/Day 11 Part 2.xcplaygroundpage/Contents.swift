import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
    
}
func calculatePowerLevel(x: Int, y: Int, serial: Int) -> Int{
    let rackID = x + 10
    var powerLevel = y * rackID
    powerLevel += serial
    powerLevel *= rackID
    powerLevel /= 100
    powerLevel = powerLevel % 10
    powerLevel -= 5
    return powerLevel
}

func calculatePoints(with serial: Int) -> [[Int]]  {
    var powerArray: [[Int]] = []
    
    for x in 0...299 {
        powerArray.append([])
        for y in 0...299 {
            powerArray[x].append(calculatePowerLevel(x: x, y: y, serial: serial))
        }
    }
    
    return powerArray
}

func calculateLargestSquare(_ powerDict: [[Int]], gridsize i: Int) -> (point: Point, value: Int, grid: Int) {
    var largestPoint: (point: Point, value: Int, grid: Int) = (Point(x: 300, y: 300), 0, 0)
    
    var sum = 0
    for x in 0..<powerDict.count - (i - 1) {
        for y in 0..<powerDict[x].count - (i - 1) {
            sum = 0
            for j in x..<x + i {
                sum += powerDict[j][y..<y + i].reduce(0, +)
            }
            if sum > largestPoint.value { largestPoint = (Point(x: x, y: y), sum, i) }
        }
    }
    
    print("The the point whose square holds the largest value is \(largestPoint.point) with a value of \(largestPoint.value) at grid size \(largestPoint.grid)x\(largestPoint.grid)")
    return largestPoint
}

//let testDict = calculatePoints(with: 18)
//calculateLargestSquare(testDict, gridsize: 3)

let powerDict = calculatePoints(with: day11Input)
var largest: (point: Point, value: Int, grid: Int) = (Point(x: 300, y: 300), 0, 0)
for i in 2...300 {
    let value = calculateLargestSquare(powerDict, gridsize: i)
    if value.value > largest.value { largest = value }
}
