//
//  ActivityType.swift
//  demoapp
//
//  Created by Morris Arroyo on 2017-11-16.
//  Copyright © 2017 Jason Sekhon. All rights reserved.
//

import UIKit

enum ActivityType: Int, CustomStringConvertible {
    case stationary, walking, running, cycling, transit, driving
    
    static let count: Int = all.count
    static let all = [stationary, walking, running, cycling, transit, driving]
    var description: String {
        switch self {
        case .stationary:
            return "Stationary"
        case .walking:
            return "Walking"
        case .cycling:
            return "Cycling"
        case .transit:
            return "Transit"
        case .driving:
            return "Driving"
        case .running:
            return "Running"
        }
    }
}
