import Foundation

struct StaticPoint: Hashable {
    let x: Int
    let y: Int
}

struct Point: Hashable {
    var x: Int
    var y: Int
    var velocityX: Int
    var velocityY: Int
    
    func locationAfter(_ seconds: Int) -> StaticPoint {
        let x = self.x + (self.velocityX * seconds)
        let y = self.y + (self.velocityY * seconds)
        
        return StaticPoint(x: x, y: y)
    }
}

func figureOutMessage(_ string: String, startingSecond: Int) {
    let array = string.components(separatedBy: .newlines)
    let characterSet = CharacterSet.lowercaseLetters.union(.symbols).union(.punctuationCharacters).union(.whitespaces).subtracting(CharacterSet(charactersIn: "-"))
    var points: Set<Point> = Set()
    for line in array {
        let input = line.components(separatedBy: characterSet).compactMap() { Int($0) }
        //print("Going to make a point from x: \(input[0]), y: \(input[1]), velocityX: \(input[2]), velocityY: \(input[3])")
        var point = Point(x: input[0], y: input[1], velocityX: input[2], velocityY: input[3])
        points.insert(point)
    }
    
    var staticPoints: Set<StaticPoint> = Set()
    var tooFarApart = true
    var seconds = startingSecond
    
    while tooFarApart {
        staticPoints = Set(points.map() { $0.locationAfter(seconds) })
        guard let minY = staticPoints.min(by: { $0.y < $1.y }),
            let maxY = staticPoints.max(by: { $0.y < $1.y }) else {
                print("Wasn't able to get min and max for some reason.")
                return
        }
        let totalHeight = maxY.y - minY.y
        print(totalHeight)
        tooFarApart = totalHeight > 9
        seconds += 1
    }
    print("It took \(seconds - 1) seconds")
    printBoard(staticPoints)

}

func printBoard(_ points: Set<StaticPoint>) {
    
    guard let minX = points.min(by: { $0.x < $1.x }),
        let maxX = points.max(by: { $0.x < $1.x }),
        let minY = points.min(by: { $0.y < $1.y }),
        let maxY = points.max(by: { $0.y < $1.y }) else { return }
    
    print("MinY: \(minY.y), MaxY: \(maxY.y), MinX: \(minX.x), MaxX: \(maxX.x)")
    
    for y in minY.y-1...maxY.y+1 {
        var line: [String] = []
        for x in minX.x-1...maxX.x+1 {
            if points.contains(StaticPoint(x: x, y: y)) {
                line.append("X")
            } else {
                line.append(".")
            }
        }
        print(line.joined(separator: " "))
    }
}

figureOutMessage(day10Input, startingSecond: 10500)
// Part 1 Answer = ZAEKAJGC
// Part 2 Answer = 10577

let testInput = """
position=< 9,  1> velocity=< 0,  2>
position=< 7,  0> velocity=<-1,  0>
position=< 3, -2> velocity=<-1,  1>
position=< 6, 10> velocity=<-2, -1>
position=< 2, -4> velocity=< 2,  2>
position=<-6, 10> velocity=< 2, -2>
position=< 1,  8> velocity=< 1, -1>
position=< 1,  7> velocity=< 1,  0>
position=<-3, 11> velocity=< 1, -2>
position=< 7,  6> velocity=<-1, -1>
position=<-2,  3> velocity=< 1,  0>
position=<-4,  3> velocity=< 2,  0>
position=<10, -3> velocity=<-1,  1>
position=< 5, 11> velocity=< 1, -2>
position=< 4,  7> velocity=< 0, -1>
position=< 8, -2> velocity=< 0,  1>
position=<15,  0> velocity=<-2,  0>
position=< 1,  6> velocity=< 1,  0>
position=< 8,  9> velocity=< 0, -1>
position=< 3,  3> velocity=<-1,  1>
position=< 0,  5> velocity=< 0, -1>
position=<-2,  2> velocity=< 2,  0>
position=< 5, -2> velocity=< 1,  2>
position=< 1,  4> velocity=< 2,  1>
position=<-2,  7> velocity=< 2, -2>
position=< 3,  6> velocity=<-1, -1>
position=< 5,  0> velocity=< 1,  0>
position=<-6,  0> velocity=< 2,  0>
position=< 5,  9> velocity=< 1, -2>
position=<14,  7> velocity=<-2,  0>
position=<-3,  6> velocity=< 2, -1>
"""

figureOutMessage(testInput, startingSecond: 0)

let point = Point(x: -3, y: 6, velocityX: 2, velocityY: -1)

