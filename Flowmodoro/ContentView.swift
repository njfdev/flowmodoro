//
//  ContentView.swift
//  Flowmodoro
//
//  Created by Nicholas Fasching on 3/6/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var timerMode = TimerTypes.Stopwatch
    @State private var timerLength = 0
    @State private var timerValue = 0
    
    var body: some View {
        VStack {
            Text("Flowmodoro")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding(.top)
            Spacer()
            ZStack {
                TimerView(mode: timerMode, timerLength: $timerLength, timerValue: $timerValue)
                    .frame(width: 275)
                Button(timerMode == TimerTypes.Countdown ? "End Break" : "Start Break") {
                    if (timerMode == TimerTypes.Countdown) {
                        timerLength = 0
                        timerValue = 0
                        timerMode = TimerTypes.Stopwatch
                    } else if (timerMode == TimerTypes.Stopwatch) {
                        timerLength = Int(timerValue/5)
                        timerValue = timerLength
                        print(timerLength, timerValue)
                        timerMode = TimerTypes.Countdown
                    }
                }
                .foregroundColor(.blue.opacity(0.8))
                .font(.system(size: 24, weight: .bold))
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
