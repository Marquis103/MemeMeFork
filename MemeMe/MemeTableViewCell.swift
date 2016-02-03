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

        // Configure the view for the selected state
    }

	override func layoutSubviews() {
		super.layoutSubviews()
		memeTextLabel.contentMode = UIViewContentMode.Left
		//memeImage.image.image
//		self.memeImage.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
	}
}
