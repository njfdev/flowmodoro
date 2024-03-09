//
//  Counter.swift
//  Flowmodoro
//
//  Created by Nicholas Fasching on 3/9/24.
//

import Foundation
import Combine

class Counter: ObservableObject {
    @Published private(set) var mode = TimerTypes.Stopwatch
    @Published var timerValue = 0
    @Published var progress = 0.0
    @Published var isRunning = false
    
    private var startTime: Date? { didSet { saveStartTime() } }
    private var timer: AnyCancellable?
    private var timerLength = 0
    
    init() {
        startTime = fetchStartTime()
        timerValue = fetchElapsedTime() ?? 0
        
        if (startTime != nil) {
            start()
        }
    }
}

extension Counter {
    func start() {
        timer?.cancel()
        
        mode = fetchTimerType()
        startTime = fetchStartTime()
        timerValue = fetchElapsedTime() ?? 0
        
        if startTime == nil {
            startTime = Date().addingTimeInterval(Double(-(mode == TimerTypes.Stopwatch ? timerValue : timerLength - timerValue)))
        }
        
        updateProgress()
        
        saveStartTime()
        saveElapsedTime()
        
        timer = Timer
            .publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard
                    let self = self,
                    let startTime = self.startTime
                else { return }
                
                let now = Date()
                let elapsed = now.timeIntervalSince(startTime)
                
                guard (elapsed < Double(self.timerLength)) || self.mode == TimerTypes.Stopwatch else {
                    self.stop()
                    return
                }
                
                self.timerValue = self.mode == TimerTypes.Stopwatch ? Int(elapsed) : Int(ceil(Double(timerLength) - Double(elapsed)))
                updateProgress()
            }
        isRunning = true
    }
    
    func setMode(mode: TimerTypes, newTimerLength: Int? = nil) {
        stop()
        self.mode = mode
        saveTimerType()
        self.progress = 0
        if (newTimerLength != nil) {
            setTimerLength(length: newTimerLength!)
        } else {
            start()
        }
    }
    
    func updateProgress() {
        if (self.mode == TimerTypes.Countdown) {
            self.progress = Double(self.timerLength - self.timerValue) / Double(self.timerLength)
        }
    }
    
    func setTimerLength(length: Int) {
        guard length >= 0 else { return }
        
        self.pause()
        self.timerLength = length
        self.timerValue = length
        saveElapsedTime()
        self.start()
    }
    
    func reset() {
        if (mode == TimerTypes.Countdown) {
            setTimerLength(length: timerLength)
        } else if (mode == TimerTypes.Stopwatch) {
            setTimerLength(length: 0)
        }
    }
    
    func pause() {
        timer?.cancel()
        timer = nil
        isRunning = false
        startTime = nil
        saveElapsedTime()
        saveStartTime()
        updateProgress()
    }
    
    func stop() {
        pause()
        timerValue = 0
        saveElapsedTime()
        updateProgress()
    }
}

private extension Counter {
    func saveStartTime() {
        if let startTime = startTime {
            UserDefaults.standard.set(startTime, forKey: "startTime")
        } else {
            UserDefaults.standard.removeObject(forKey: "startTime")
        }
    }
    
    func fetchStartTime() -> Date? {
        UserDefaults.standard.object(forKey: "startTime") as? Date
    }
    
    
    func saveElapsedTime() {
        UserDefaults.standard.set(timerValue, forKey: "elapsedTime")
    }
    
    func fetchElapsedTime() -> Int? {
        UserDefaults.standard.object(forKey: "elapsedTime") as? Int
    }
    
    
    func saveTimerType() {
        UserDefaults.standard.set(mode.rawValue, forKey: "timerType")
    }
    
    func fetchTimerType() -> TimerTypes {
        TimerTypes(rawValue: (UserDefaults.standard.object(forKey: "timerType") as? Int) ?? TimerTypes.Stopwatch.rawValue) ?? TimerTypes.Stopwatch
    }
} 
