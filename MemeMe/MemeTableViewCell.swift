//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Marquis Dennis on 2/2/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

	@IBOutlet weak var memeTextLabel: UILabel!
	@IBOutlet weak var memeImage: UIImageView!

	
	override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
