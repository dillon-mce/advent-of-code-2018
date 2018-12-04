import Foundation


let inputData = day4Input.components(separatedBy: CharacterSet(charactersIn: "\n")).sorted()
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
var currentGuard = ""
var timestampDict: [String: [Date]] = [:]

for i in 0..<inputData.count {
    let components = inputData[i].components(separatedBy: CharacterSet(charactersIn: "[]"))
    //print(components)
    if components[2].hasPrefix(" Guard") {
        let num = components[2].components(separatedBy: .whitespaces)[2]
        currentGuard = num
        continue
    }
    
    
    
    guard let date = dateFormatter.date(from: components[1]) else { continue }
    
    timestampDict[currentGuard, default: []].append(date)
    //
    //    let dateInterval = DateInterval(start: previousDate, end: date)
    //    print(dateInterval.duration/60)
    //    lastDate = date
}

var sleepCount: [String: Int] = [:]
for (key, value) in timestampDict {
    for index in 0..<value.count-1 {
        if index % 2 == 0 {
            let interval = DateInterval(start: value[index], end: value[index+1])
            let minutes = Int(interval.duration/60)
            sleepCount[key, default: 0] += minutes
        }
    }
}

let biggest = sleepCount.max() { $0.value < $1.value }


let sleepyGuardArray = timestampDict["#1777"] ?? []
let minuteFormatter = DateFormatter()
minuteFormatter.dateFormat = "mm"



var minuteDict: [String: [Int: Int]] = [:]
for (guardID, times) in timestampDict {
    for minute in 0..<60 {
        for index in 0..<times.count-1 {
            if index % 2 == 0 {
                guard let fallAsleep = Int(minuteFormatter.string(from: times[index])),
                    let wakeUp = Int(minuteFormatter.string(from: times[index+1])) else { continue }
                //print("Comparing minute \(minute) against fall asleep time of \(fallAsleep) and wake up time of \(wakeUp)")
                if minute >= fallAsleep && minute < wakeUp {
                    minuteDict[guardID, default: [:]][minute, default: 0] += 1
                }
            }
        }
    }
}



let minute = 48
let guardId = 1777

let answer = minute * guardId


