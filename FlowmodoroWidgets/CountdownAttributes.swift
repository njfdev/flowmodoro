//
//  CountdownAttributes.swift
//  Flowmodoro
//
//  Created by Nicholas Fasching on 3/11/24.
//

import ActivityKit
import SwiftUI

struct CountdownAttributes: ActivityAttributes {
    typealias ContentState = Data
    
    struct Data: Codable, Hashable {
        var startTime: Date
        var timerLength: Int
    }
}
