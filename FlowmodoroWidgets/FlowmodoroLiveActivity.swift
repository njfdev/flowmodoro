//
//  FlowmodoroLiveActivity.swift
//  FlowmodoroWidgetsExtension
//
//  Created by Nicholas Fasching on 3/9/24.
//

import SwiftUI
import WidgetKit
import ActivityKit
import Combine

func calculateEndTime(startTime: Date, timerLength: Int) -> Date {
    return .now.addingTimeInterval(max(0, CGFloat(timerLength) - Date().timeIntervalSince(startTime)))
}

struct CountdownActivityView: View {
    let context: ActivityViewContext<CountdownAttributes>
    
    var body: some View {
        HStack {
            VStack {
                Text("Break Time!")
                        .font(.system(size: 24, weight: .heavy, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text(calculateEndTime(startTime: context.state.startTime, timerLength: context.state.timerLength), style: .timer)
                .font(.system(size: 32, weight: .black, design: .default))
                .foregroundStyle(.blue)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.leading)
        }
        .padding()
    }
}

@main
struct CountdownActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CountdownAttributes.self) { context in
            CountdownActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                expandedContent(context: context)
            } compactLeading: {
                
            } compactTrailing: {
                
            } minimal: {
                
            }
        }
    }
}

@DynamicIslandExpandedContentBuilder
private func expandedContent(context: ActivityViewContext<CountdownAttributes>) -> DynamicIslandExpandedContent<some View> {
    DynamicIslandExpandedRegion(.bottom) {
        Text("a")
    }
}
