//
//  Song.swift
//  demoapp
//
//  Created by Morris Arroyo on 2017-11-17.
//  Copyright © 2017 Jason Sekhon. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class Song: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var artist: String
    var albumCover: UIImage
    var playlistId: Int
    
    init(title: String, artist: String, albumCover: UIImage, playlistId: Int) {
        self.title = title
        self.artist = artist
        self.albumCover = albumCover
        self.playlistId = playlistId
    }
}

