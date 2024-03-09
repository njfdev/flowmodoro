//
//  TimerView.swift
//  Flowmodoro
//
//  Created by Nicholas Fasching on 3/8/24.
//

import SwiftUI
import Combine

let timerLength = (0.5 * 60 * 60) / 5.0

public enum TimerTypes {
    case Stopwatch
    case Countdown
}


func runTimer() -> Publishers.Autoconnect<Timer.TimerPublisher> {
    return Timer.publish(every: 1, on: .main, in: .common).autoconnect()
}

struct TimerView: View {
    let mode: TimerTypes
    
    @State private var timeRemaining = timerLength
    @State private var timer = runTimer()
    @State private var isTimerRunning = true
    
    let formatter = DateComponentsFormatter()
    
    var body: some View {
        VStack {
            ZStack {
                CircularProgressView(progress: (timerLength-timeRemaining)/timerLength)
                Text(formatter.string(from: timeRemaining)!)
                    .fontWeight(.black)
                    .lineLimit(1)
                    .font(.system(size: 48))
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                    .padding(.all, 25)
                    .onReceive(timer) { _ in
                        if isTimerRunning && timeRemaining > 0 {
                            timeRemaining -= 1
                        }
                    }
            }
            .onAppear() {
                formatter.allowedUnits = [.hour, .minute, .second]
                formatter.unitsStyle = .positional
            }
            HStack {
                Button() {
                    isTimerRunning = !isTimerRunning
                } label: {
                    isTimerRunning ? Image(systemName: "pause.fill") : Image(systemName: "play.fill")
                }
                Button() {
                    timeRemaining = timerLength
                } label: {
                    Image(systemName: "gobackward")
                }
            }
            .font(.system(size: 48))
            .foregroundStyle(.foreground)
            .padding(.top)
        }
    }
}

#Preview {
    TimerView(mode: TimerTypes.Countdown)
}
