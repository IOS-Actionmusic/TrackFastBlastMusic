//
//  ActivityLeftTableViewCell.swift
//  demoapp
//
//  Created by Morris Arroyo on 2017-11-16.
//  Copyright © 2017 Jason Sekhon. All rights reserved.
//

import UIKit

class ActivityLeftTableViewCell: UITableViewCell {

    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var editImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
