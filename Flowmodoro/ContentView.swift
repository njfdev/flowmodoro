//
//  ContentView.swift
//  Flowmodoro
//
//  Created by Nicholas Fasching on 3/6/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            Text("Flowmodoro")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .padding(.top)
            Spacer()
            TimerView(mode: TimerTypes.Countdown)
                .frame(width: 275)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
