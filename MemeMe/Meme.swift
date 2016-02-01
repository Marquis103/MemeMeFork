//
//  Meme.swift
//  MemeMe
//
//  Created by Marquis Dennis on 1/31/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

struct Meme {
  var topText:String
  var bottomText:String
  var originalImage:UIImage
  var memedImage:UIImage
  
  init(topText:String, bottomText:String, originalImage:UIImage, memedImage: UIImage) {
    self.topText = topText
    self.bottomText = bottomText
    self.originalImage = originalImage
    self.memedImage = memedImage
  }
}