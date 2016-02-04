//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Marquis Dennis on 2/2/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {

	@IBOutlet weak var memeImageView: UIImageView!
	
	var meme:MemeModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		memeImageView.image = (meme?.memedImage)!
	}
	
	
}
