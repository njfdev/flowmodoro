//
//  CircularProgressView.swift
//  Flowmodoro
//
//  Created by Nicholas Fasching on 3/7/24.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.gray.opacity(0.5),
                    lineWidth: 20
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.blue,
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                    )
                )
                .animation(.easeOut, value: progress)
        }
        .rotationEffect(.degrees(-90))
    }
}

#Preview {
    CircularProgressView(progress: 0.35)
}
