//
//  Activity.swift
//  demoapp
//
//  Created by Morris Arroyo on 2017-11-16.
//  Copyright © 2017 Jason Sekhon. All rights reserved.
//

import UIKit

class Activity: NSObject {
    var name: String
    var id: Int
    
    init(name: String, id: Int) {
        self.name   = name
        self.id   = id
    }
}
