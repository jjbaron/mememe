//
//  MemeTableViewController.swift
//  
//
//  Created by Jeff Baron on 5/14/15.
//
//

import UIKit

class MemeTableViewController: UITableViewController  {

  var memes: [Meme]!
  
  // flag to determine if we called MemeEditorViewController once initially when meme count was 0
  var didInitView = false
  
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
    self.tableView.delegate = self
    self.tableView.reloadData()
  }
  
  func getAppDelegate() -> AppDelegate {
    
    let object = UIApplication.sharedApplication().delegate
    let appDelegate = object as! AppDelegate
    
    return appDelegate

  }
  
}
    // MARK: - Table view data source

  extension MemeTableViewController: UITableViewDataSource {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
      let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell") as! MemeTableViewCell
      let meme = self.memes[indexPath.row]
      cell.imageView?.image = meme.memedImage
      cell.contentMode = .ScaleAspectFit
      cell.textLabel?.text = meme.topText + "..." + meme.bottomText
    
      return cell
    }
  
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
      let detailController = self.storyboard!.instantiateViewControllerWithIdentifier(detailViewControllerIdentifier) as! MemeDetailViewController
      detailController.meme = self.memes[indexPath.row]
      self.navigationController!.pushViewController(detailController, animated: true)

    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if editingStyle == .Delete {
        // remove meme from self meme array and from AppDelegate
        self.memes.removeAtIndex(indexPath.row)
        getAppDelegate().memes.removeAtIndex(indexPath.row)

        // delete the row from the data source
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        self.tableView.reloadData()
      }
    }

}
