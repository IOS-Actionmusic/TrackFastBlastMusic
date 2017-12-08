//
//  PlaylistSongTableViewCell.swift
//  demoapp
//
//  Created by Morris Arroyo on 2017-11-17.
//  Copyright © 2017 Jason Sekhon. All rights reserved.
//

import UIKit

class PlaylistSongTableViewCell: UITableViewCell {

    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
