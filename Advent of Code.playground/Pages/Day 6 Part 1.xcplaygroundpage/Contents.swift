import Foundation

struct Point: Hashable {
    var x: Int
    var y: Int
    
    func calculateDistance(from point: Point) -> Int {
       return abs(self.x - point.x) + abs(self.y - point.y)
    }
}

func calculateLargestArea(_ string: String) -> (key: Point, value: [Point])? {
    let array = string.components(separatedBy: CharacterSet(charactersIn: "\n"))
    
    let pointArray = array.compactMap() { string -> Point? in
        let array = string.components(separatedBy: .punctuationCharacters).joined().components(separatedBy: .whitespaces)
        guard array.count > 1, let x = Int(array[0]), let y = Int(array[1]) else { return nil }
        let point = Point(x: x, y: y)
        return point
    }
    guard let maxX = pointArray.max(by: { $0.x < $1.x }), let maxY = pointArray.max(by: { $0.y < $1.y }), let minX = pointArray.min(by: { $0.x < $1.x }), let minY = pointArray.min(by: { $0.y < $1.y }) else { return nil }
    
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
    for (point, array) in filteredDict {
        print("\(point) is the closest to \(array.count) points")
    }
    
    let biggestArea = filteredDict.max(by: { $0.value.count < $1.value.count })
    
    return biggestArea
}


let testData = """
1, 1
1, 6
8, 3
3, 4
5, 5
8, 9
"""

calculateLargestArea(testData)

let biggest = calculateLargestArea(day6Input)
print(biggest?.value.count)

// Answer: 4398
