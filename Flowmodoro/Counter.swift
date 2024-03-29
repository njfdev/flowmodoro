//
//  Counter.swift
//  Flowmodoro
//
//  Created by Nicholas Fasching on 3/9/24.
//

import Foundation
import Combine
import ActivityKit

class Counter: ObservableObject {
    @Published private(set) var mode = TimerTypes.Stopwatch
    @Published var timerValue = 0
    @Published var progress = 0.0
    @Published var isRunning = false
    
    private var startTime: Date? { didSet { saveStartTime() } }
    private var timer: AnyCancellable?
    private var timerLength = 0
    private var activity: Activity<CountdownAttributes>? = nil
    
    init() {
        mode = fetchTimerType()
        startTime = fetchStartTime()
        timerValue = fetchElapsedTime() ?? 0
        
        if (startTime != nil) {
            start()
        } else if (fetchTimerLength() != nil) {
            updateProgress()
        }
    }
}

extension Counter {
    func start() {
        timer?.cancel()
        
        mode = fetchTimerType()
        startTime = fetchStartTime()
        timerValue = fetchElapsedTime() ?? 0
        timerLength = fetchTimerLength() ?? 0
        
        if startTime == nil {
            startTime = Date().addingTimeInterval(Double(-(mode == TimerTypes.Stopwatch ? timerValue : (timerLength - timerValue))))
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
        
        if (mode == TimerTypes.Countdown) {
            startActivity()
        }
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
        saveTimerLength()
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
        saveTimerLength()
        updateProgress()
        stopActivity()
    }
    
    func stop() {
        pause()
        timerValue = 0
        saveElapsedTime()
        updateProgress()
    }
}

private extension Counter {
    func startActivity() {
        if (activity != nil) {
            Task {
                await activity?.end(nil, dismissalPolicy: .immediate)
            }
        }
        
        let attributes = CountdownAttributes()
        let state = CountdownAttributes.ContentState(startTime: startTime ?? .now, timerLength: timerLength)
        let content = ActivityContent(state: state, staleDate: nil)
        
        activity = try? Activity<CountdownAttributes>.request(attributes: attributes, content: content, pushType: nil)
    }
    
    func stopActivity() {
        let state = CountdownAttributes.ContentState(startTime: startTime ?? .now, timerLength: timerLength)
        let content = ActivityContent(state: state, staleDate: nil)
        
        Task {
            await activity?.end(content, dismissalPolicy: .immediate)
        }
    }
    
    func updateActivity() {
        let state = CountdownAttributes.ContentState(startTime: startTime ?? .now, timerLength: timerLength)
        let content = ActivityContent(state: state, staleDate: nil)
        
        Task {
            await activity?.update(content)
        }
    }
    
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
    
    
    func saveTimerLength(){
        UserDefaults.standard.set(timerLength, forKey: "timerLength")
    }
    
    func fetchTimerLength() -> Int? {
        UserDefaults.standard.object(forKey: "timerLength") as? Int
    }
}
