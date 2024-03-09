//
//  ContentView.swift
//  Flowmodoro
//
//  Created by Nicholas Fasching on 3/6/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var counter = Counter()
    
    var body: some View {
        VStack {
            Text("Flowmodoro")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding(.top)
            Spacer()
            ZStack {
                TimerView(counter: counter)
                    .frame(width: 275)
                Button(counter.mode == TimerTypes.Countdown ? "End Break" : "Start Break") {
                    if (counter.mode == TimerTypes.Countdown) {
                        counter.setMode(mode: TimerTypes.Stopwatch)
                    } else if (counter.mode == TimerTypes.Stopwatch) {
                        counter.setMode(mode: TimerTypes.Countdown, newTimerLength: counter.timerValue/5)
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
