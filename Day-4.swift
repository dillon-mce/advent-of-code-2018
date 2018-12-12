#!/usr/bin/swift
import Cocoa
let input = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""
var day = "DAY 4"
day += input == "" ? " – TEST" : ""
let underscores = Array(repeating: "—", count: day.count).joined()

print("\n\(underscores)\n\(day)\n\(underscores)")

// Part 1
func findSleepyGuard1(_ string: String) -> Int {
    let inputData = string.components(separatedBy: CharacterSet(charactersIn: "\n")).sorted()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    var currentGuard = ""
    var timestampDict: [String: [Date]] = [:]
    
    for i in 0..<inputData.count {
        let components = inputData[i].components(separatedBy: CharacterSet(charactersIn: "[]"))
        if components[2].hasPrefix(" Guard") {
            let num = components[2].components(separatedBy: .whitespaces)[2]
            currentGuard = num
            continue
        }
        
        guard let date = dateFormatter.date(from: components[1]) else { continue }
        
        timestampDict[currentGuard, default: []].append(date)
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
    
    guard let biggest = sleepCount.max(by: { $0.value < $1.value }) else { return -1 }
    
    
    let sleepyGuardArray = timestampDict[biggest.key] ?? []
    let minuteFormatter = DateFormatter()
    minuteFormatter.dateFormat = "mm"
    
    var minuteDict: [Int: Int] = [:]
    for minute in 0..<60 {
        for index in 0..<sleepyGuardArray.count-1 {
            if index % 2 == 0 {
                guard let fallAsleep = Int(minuteFormatter.string(from: sleepyGuardArray[index])),
                    let wakeUp = Int(minuteFormatter.string(from: sleepyGuardArray[index+1])) else { continue }
                if minute >= fallAsleep && minute < wakeUp {
                    minuteDict[minute, default: 0] += 1
                }
            }
        }
    }
    
    guard let frequentlyAsleep = minuteDict.max(by: { $0.value < $1.value }) else { return -1 }
    
    let minute = frequentlyAsleep.key
    let guardId = Int(biggest.key.components(separatedBy: CharacterSet(charactersIn: "#")).joined()) ?? 0
    
    return minute * guardId
}


let test1 = """
[1518-11-01 00:00] Guard #10 begins shift
[1518-11-01 00:05] falls asleep
[1518-11-01 00:25] wakes up
[1518-11-01 00:30] falls asleep
[1518-11-01 00:55] wakes up
[1518-11-01 23:58] Guard #99 begins shift
[1518-11-02 00:40] falls asleep
[1518-11-02 00:50] wakes up
[1518-11-03 00:05] Guard #10 begins shift
[1518-11-03 00:24] falls asleep
[1518-11-03 00:29] wakes up
[1518-11-04 00:02] Guard #99 begins shift
[1518-11-04 00:36] falls asleep
[1518-11-04 00:46] wakes up
[1518-11-05 00:03] Guard #99 begins shift
[1518-11-05 00:45] falls asleep
[1518-11-05 00:55] wakes up
"""

assert(findSleepyGuard1(test1) == 240)

// Part 2
func findSleepyGuard2(_ string: String) -> Int {
    let inputData = string.components(separatedBy: CharacterSet(charactersIn: "\n")).sorted()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    var currentGuard = ""
    var timestampDict: [String: [Date]] = [:]
    
    for i in 0..<inputData.count {
        let components = inputData[i].components(separatedBy: CharacterSet(charactersIn: "[]"))
        if components[2].hasPrefix(" Guard") {
            let num = components[2].components(separatedBy: .whitespaces)[2]
            currentGuard = num
            continue
        }
        
        guard let date = dateFormatter.date(from: components[1]) else { continue }
        
        timestampDict[currentGuard, default: []].append(date)
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
    
    let minuteFormatter = DateFormatter()
    minuteFormatter.dateFormat = "mm"
    
    var minuteDict: [String: [Int: Int]] = [:]
    for (guardID, times) in timestampDict {
        for minute in 0..<60 {
            for index in 0..<times.count-1 {
                if index % 2 == 0 {
                    guard let fallAsleep = Int(minuteFormatter.string(from: times[index])),
                        let wakeUp = Int(minuteFormatter.string(from: times[index+1])) else { continue }
                    if minute >= fallAsleep && minute < wakeUp {
                        minuteDict[guardID, default: [:]][minute, default: 0] += 1
                    }
                }
            }
        }
    }
    
    var mostMinutes: (key: Int, value: Int) = (0, 0)
    var consistentlySleepyGuard = ""
    for (guardId, dict) in minuteDict {
        guard let max = dict.max(by: { $0.value < $1.value }) else { continue }
        //print("Guard \(guardId) was asleep at minute \(max.key) \(max.value) times")
        if max.value > mostMinutes.value {
            mostMinutes = max
            consistentlySleepyGuard = guardId
        }
    }
    
    let minute = mostMinutes.key
    let guardId = Int(consistentlySleepyGuard.components(separatedBy: CharacterSet(charactersIn: "#")).joined()) ?? 0
    
    return minute * guardId
}

let test2 = test1
assert(findSleepyGuard2(test2) == 4455)

func findAnswers(_ string: String) {
    var string = string
    if string.isEmpty { string = test1 }

    var startTime = CFAbsoluteTimeGetCurrent()
    let answer1 = findSleepyGuard1(string)
    print("Part 1 Answer: \(answer1)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")

    if string == test1 { string = test2 }

    startTime = CFAbsoluteTimeGetCurrent()
    let answer2 = findSleepyGuard2(string)
    print("Part 2 Answer: \(answer2)\nFound in \(CFAbsoluteTimeGetCurrent() - startTime) seconds\n")
}


findAnswers(input)


