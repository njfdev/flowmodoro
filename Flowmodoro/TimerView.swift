//
//  TimerView.swift
//  Flowmodoro
//
//  Created by Nicholas Fasching on 3/8/24.
//

import SwiftUI
import Combine

public enum TimerTypes: Int {
    case Stopwatch
    case Countdown
}

struct TimerView: View {
    @ObservedObject var counter: Counter
    
    let formatter = DateComponentsFormatter()
    
    var body: some View {
        VStack {
            ZStack {
                CircularProgressView(progress: counter.progress)
                Text((counter.mode == TimerTypes.Countdown && counter.timerValue == 0) ? "Done!" : formatter.string(from: Double(counter.timerValue))!)
                    .fontWeight(.black)
                    .lineLimit(1)
                    .font(.system(size: 48))
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                    .padding(.all, 25)
            }
            .onAppear() {
                formatter.allowedUnits = [.hour, .minute, .second]
                formatter.unitsStyle = .positional
            }
            HStack {
                Button() {
                    if counter.isRunning {
                        counter.pause()
                    } else {
                        counter.start()
                    }
                } label: {
                    counter.isRunning ? Image(systemName: "pause.fill") : Image(systemName: "play.fill")
                }
                Button() {
                    counter.reset()
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
        @StateObject var counter = Counter()
        
        var body: some View {
            TimerView(counter: counter)
        }
    }
    
    return Preview()
}
