//
//  TimerView.swift
//  Flowmodoro
//
//  Created by Nicholas Fasching on 3/8/24.
//

import SwiftUI
import Combine

public enum TimerTypes {
    case Stopwatch
    case Countdown
}


func runTimer() -> Publishers.Autoconnect<Timer.TimerPublisher> {
    return Timer.publish(every: 1, on: .main, in: .common).autoconnect()
}

struct TimerView: View {
    let mode: TimerTypes
    
    
    @Binding var timerLength: Int
    @Binding var timerValue: Int
    @State private var timer = runTimer()
    @State private var isTimerRunning = true
    
    let formatter = DateComponentsFormatter()
    
    var body: some View {
        VStack {
            ZStack {
                CircularProgressView(progress: ((mode == TimerTypes.Countdown) && (timerLength > 0)) ? (Double((timerLength-timerValue))/Double(timerLength)) : 0)
                Text((mode == TimerTypes.Countdown && timerValue == 0) ? "Done!" : formatter.string(from: Double(timerValue))!)
                    .fontWeight(.black)
                    .lineLimit(1)
                    .font(.system(size: 48))
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                    .padding(.all, 25)
                    .onReceive(timer) { _ in
                        if isTimerRunning && (timerValue > 0 || mode == TimerTypes.Stopwatch) {
                            timerValue += mode == TimerTypes.Countdown ? -1 : 1
                        }
                    }
            }
            .onAppear() {
                formatter.allowedUnits = [.hour, .minute, .second]
                formatter.unitsStyle = .positional
                if (mode == TimerTypes.Countdown) {
                    timerValue = timerLength
                }
            }
            HStack {
                Button() {
                    isTimerRunning = !isTimerRunning
                } label: {
                    isTimerRunning ? Image(systemName: "pause.fill") : Image(systemName: "play.fill")
                }
                Button() {
                    timerValue = timerLength
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
    struct Preview: View {
        @State var timerLength = 5*60
        @State var timerValue = 5*60
        
        var body: some View {
            TimerView(mode: TimerTypes.Countdown, timerLength: $timerLength, timerValue: $timerValue)
        }
    }
    
    return Preview()
}
