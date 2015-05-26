//
//  Meme.swift
//  MemeMe
//
//  Created by Jeff Baron on 5/3/15.
//  Copyright (c) 2015 Jeff Baron. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
  var topText: String
  var bottomText: String
  var originalImage: UIImage?
  var memedImage: UIImage?
  
  
  init(topText: String, bottomText: String, originalImage: UIImage?, memedImage: UIImage?) {
    self.topText = topText
    self.bottomText = bottomText
    self.originalImage = originalImage
    self.memedImage = memedImage
  }

}