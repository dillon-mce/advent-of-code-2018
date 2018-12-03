import Foundation

struct Point: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int
    
    var description: String {
        return "Point(x: \(x), y: \(y))"
    }
    
}

struct Claim {
    let id: String
    let x: Int
    let y: Int
    let height: Int
    let width: Int
    
    func contains(_ point: Point) -> Bool {
        return point.x >= self.x && point.x < (self.x + self.width) && point.y >= self.y && point.y < (self.y + self.height)
    }
    var internalPoints: Set<Point> {
        var set: Set<Point> = Set()
        for x in x..<(x + width) {
            for y in y..<(y + height) {
                let point = Point(x: x, y: y)
                set.insert(point)
            }
        }
        return set
    }
//
//    init (id: String, x: Int, y: Int, height: Int, width: Int) {
//        self.id = id
//        self.x = x
//        self.y = y
//        self.height = height
//        self.width = width
//
//        self.internalPoints =
//    }
    
//    func getIntersectionPoints(with claims: [Claim]) -> Set<Point> {
//        var points: Set<Point> = Set()
//        let internalPoints = self.internalPoints
//        for claim in claims {
//            points.formUnion(internalPoints.intersection(claim.internalPoints))
//        }
//        return points
//    }
    
    func getIntersectionPoints(with claim: Claim) -> Set<Point> {
        var points: Set<Point> = Set()
        points.formUnion(self.internalPoints.intersection(claim.internalPoints))
        return points
    }
    
    func overlappingArea(with claim: Claim) -> Int {
        let overlapX = min((self.x + self.width), (claim.x + claim.width)) - max(self.x, claim.x)
        let overlapY = min((self.y + self.height), (claim.y + claim.height)) - max(self.y, claim.y)
        
        guard overlapX > 0, overlapY > 0 else { return 0 }

        return overlapX * overlapY > 0 ? overlapX * overlapY : 0

    }
    
}

//func overlappingPoints(_ claims: [Claim]) -> Set<Point> {
//    var set: Set<Point> = Set()
//    for i in 0..<claims.count {
//        for j in i+1..<claims.count {
//            let claim1 = claims[i]
//            let claim2 = claims[j]
//
//        }
//    }
//    return overlap
//}

func addOverlappingArea(_ claims: [Claim]) -> Set<Point> {
    //var overlap: Int = 0
    var points: Set<Point> = Set()
    for i in 0..<claims.count {
        for j in i+1..<claims.count {
            let claim1 = claims[i]
            let claim2 = claims[j]
            if claim1.overlappingArea(with: claim2) > 0 {
                points.formUnion(claim1.getIntersectionPoints(with: claim2))
            }
        }
    }
    return points
}

//func getAllIntersectionPoints(_ claims: [Claim]) -> Set<Point> {
//    var points: Set<Point> = Set()
//    for i in 0..<claims.count {
//        let array = Array(claims.suffix(claims.count - (i+1)))
//        points.formUnion(claims[i].getIntersectionPoints(with: array))
//    }
//    return points
//}

func parseInput(_ string: String) -> [Claim] {
    let newLines = CharacterSet(charactersIn: "\n")
    let array = string.components(separatedBy: newLines)
    var results: [Claim] = []
    
    for (index, item) in array.enumerated() {
        let secondArray = item.components(separatedBy: .whitespaces)
        let id = secondArray[0]
        let originArray = secondArray[2].components(separatedBy: .punctuationCharacters)
        let boundsArray = secondArray[3].components(separatedBy: CharacterSet(charactersIn: "x"))
        guard let x = Int(originArray[0]),
            let y = Int(originArray[1]),
            let width = Int(boundsArray[0]),
            let height = Int(boundsArray[1]) else {
                print("Couldn't convert something correctly. Check loop \(index + 1)")
                print("Array: \(secondArray)")
                continue
            }
        let claim = Claim(id: id, x: x, y: y, height: height, width: width)
        results.append(claim)
    }
    
    return results
}

let test1 = """
#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2
#4 @ 6,5: 2x2
#5 @ 0,0: 2x2
"""

let testClaims = parseInput(test1)
let claims = parseInput(day3Input)

//let testPoints = getAllIntersectionPoints(testClaims)
//print(testPoints.count)

//let overlappingPoints = getAllIntersectionPoints(claims)
//print(overlappingPoints.count)

addOverlappingArea(testClaims).count
let overlappingPoints = addOverlappingArea(claims)

print(overlappingPoints.count)
