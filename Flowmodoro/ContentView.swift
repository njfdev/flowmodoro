//
//  ContentView.swift
//  Flowmodoro
//
//  Created by Nicholas Fasching on 3/6/24.
//

import SwiftUI

let timerLength = (0.5 * 60 * 60) / 5.0

struct ContentView: View {
    @State var timeRemaining = timerLength
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let formatter = DateComponentsFormatter()
    
    var body: some View {
        VStack {
            Text("Flowmodoro")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding(.top)
            Spacer()
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
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        }
                    }
            }
            .frame(width: 200, height: 200)
            Spacer()
        }
        .padding()
        .onAppear() {
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
        }
    }
}

#Preview {
    ContentView()
}
