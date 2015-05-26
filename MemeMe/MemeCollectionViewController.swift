//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Jeff Baron on 5/19/15.
//  Copyright (c) 2015 Jeff Baron. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
 
  var memes: [Meme]!
  
  // flag to determine if we called MemeEditorViewController once initially when meme count was 0
  var didInitView = false
  
  let reuseIdentifier = "MemeCollectionCell"
  let detailViewControllerIdentifier = "MemeDetailViewController"
  let addMemeIdentifier = "createMeme"

  @IBAction func addMeme(sender: UIBarButtonItem) {
     self.performSegueWithIdentifier(addMemeIdentifier, sender: self)
  }
  
  override func viewWillAppear(animated: Bool) {
    
    let appDelegate = getAppDelegate();
    memes = appDelegate.memes
    didInitView = appDelegate.didInitView
    
    if (memes.count == 0 && !didInitView) {
      appDelegate.didInitView = true
      self.performSegueWithIdentifier(addMemeIdentifier, sender: self)
    }    
    self.collectionView!.delegate = self
    self.collectionView!.reloadData()
    
  }
  
  func getAppDelegate() -> AppDelegate {
    
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
    
    return appDelegate
    
  }

  
}
  // MARK: Collection view data source delegate
  
  extension MemeCollectionViewController: UICollectionViewDataSource {

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
      return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
      var meme = self.memes[indexPath.row]
      cell.memeImage?.image = meme.memedImage
      cell.contentMode = .ScaleAspectFit
      
      return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
      let detailController = self.storyboard!.instantiateViewControllerWithIdentifier(detailViewControllerIdentifier) as! MemeDetailViewController
      detailController.meme = self.memes[indexPath.row]
      self.navigationController!.pushViewController(detailController, animated: true)
    }

}


