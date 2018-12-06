import Foundation

struct Point: Hashable {
    var x: Int
    var y: Int
    
    func calculateDistance(from point: Point) -> Int {
        return abs(self.x - point.x) + abs(self.y - point.y)
    }
}

func calculateLargestArea(_ string: String, targetValue: Int) -> Int? {
    let array = string.components(separatedBy: CharacterSet(charactersIn: "\n"))
    
    let pointArray = array.compactMap() { string -> Point? in
        let array = string.components(separatedBy: .punctuationCharacters).joined().components(separatedBy: .whitespaces)
        guard array.count > 1, let x = Int(array[0]), let y = Int(array[1]) else { return nil }
        let point = Point(x: x, y: y)
        return point
    }
    guard let maxX = pointArray.max(by: { $0.x < $1.x }), let maxY = pointArray.max(by: { $0.y < $1.y }), let minX = pointArray.min(by: { $0.x < $1.x }), let minY = pointArray.min(by: { $0.y < $1.y }) else { return nil }
    
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
    
    print(safePoints.count)
    return safePoints.count
}


let testData = """
1, 1
1, 6
8, 3
3, 4
5, 5
8, 9
"""

calculateLargestArea(testData, targetValue: 32)

let biggest = calculateLargestArea(day6Input, targetValue: 10000)

