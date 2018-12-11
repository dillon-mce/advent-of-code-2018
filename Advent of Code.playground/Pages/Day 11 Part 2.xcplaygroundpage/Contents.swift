struct Point: Hashable {
    let x: Int
    let y: Int
    
}
func calculatePowerLevel(_ point: Point, serial: Int) -> Int{
    let rackID = point.x + 10
    var powerLevel = point.y * rackID
    powerLevel += serial
    powerLevel *= rackID
    powerLevel /= 100
    powerLevel = powerLevel % 10
    powerLevel -= 5
    return powerLevel
}

func calculatePoints(with serial: Int) -> [Point: Int]  {
    var powerDict: [Point: Int] = [:]
    
    for x in 1...300 {
        for y in 1...300 {
            let point = Point(x: x, y: y)
            powerDict[point] = calculatePowerLevel(point, serial: serial)
        }
    }
    
    return powerDict
}

func calculateLargestSquare(_ powerDict: [Point: Int]) -> Point {
    var largestPoint: (point: Point, value: Int) = (Point(x: 300, y: 300), 0)
    
    for i in 2...300 {
        for point in powerDict.keys {
            var sum = 0
            if powerDict[Point(x: point.x + (i - 1), y: point.y + (i - 1))] != nil {
                for x in point.x...point.x + (i - 1) {
                    for y in point.y...point.y + (i - 1) {
                        sum += powerDict[Point(x: x, y: y)]!
                    }
                }
                if sum > largestPoint.value { largestPoint = (point, sum) }
            }
        }
    }
    
    print("The the point whose square holds the largest value is \(largestPoint.point) with a value of \(largestPoint.value)")
    return largestPoint.point
}

//let testDict = calculatePoints(with: 18)
//calculateLargestSquare(testDict)

let powerDict = calculatePoints(with: day11Input)
calculateLargestSquare(powerDict)
