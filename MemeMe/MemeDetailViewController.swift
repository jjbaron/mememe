//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Jeff Baron on 5/22/15.
//  Copyright (c) 2015 Jeff Baron. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
  
  var meme: Meme!
  
  @IBOutlet weak var memeImageView: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      if let memeImage = meme.memedImage{
        self.memeImageView.image = memeImage
      }
    }
}
