//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Jeff Baron on 4/16/15.
//  Copyright (c) 2015 Jeff Baron. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

  @IBOutlet weak var imagePickerView: UIImageView!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var topText: UITextField!
  @IBOutlet weak var bottomText: UITextField!
  @IBOutlet weak var toolbar: UIToolbar!
  @IBOutlet weak var shareButton: UIBarButtonItem!
  
  var memedImage: UIImage?
  
  let memeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.blackColor(),
    NSForegroundColorAttributeName : UIColor.whiteColor(),
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName : -3.0
  ]
  
 
  override func viewDidLoad() {
    super.viewDidLoad()
    self.topText.delegate = self
    self.bottomText.delegate = self
    shareButton.enabled = false;
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    topText.defaultTextAttributes = memeTextAttributes
    bottomText.defaultTextAttributes = memeTextAttributes
    topText.text = "TOP"
    topText.textAlignment = NSTextAlignment.Center
    bottomText.text = "BOTTOM"
    bottomText.textAlignment = NSTextAlignment.Center

    cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    
    // Subscribe to keyboard notifications to allow the view to raise when necessary
    self.subscribeToKeyboardNotifications()
    self.subscribeToKeyboardWillHideNotifications()
    
    self.hideToolbars(false)
    
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    unsubscribeFromKeyboardNotifications()
    unsubscribeFromWillHideKeyboardNotifications()
  }

  
  func keyboardWillShow(notification: NSNotification) {
    if bottomText.isFirstResponder() {
      self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
   if bottomText.isFirstResponder() {
      self.view.frame.origin.y += getKeyboardHeight(notification)
    }
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    // clear text fields once user first starts entering text
    if (textField.text == "TOP" || textField.text == "BOTTOM") {
      textField.text = ""
    }
  }
  
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
    
  }

  @IBAction func shareButtonPressed(sender: UIBarButtonItem) {
    self.memedImage = generateMemedImage()
    let activityVC = UIActivityViewController(activityItems: [self.memedImage!], applicationActivities: nil)
    
    activityVC.completionWithItemsHandler = {
      activity, completed, items, error in
      if completed {
        self.save()
        self.dismissViewControllerAnimated(true, completion: nil)
      }
    }
    
    self.presentViewController(activityVC, animated: true, completion: nil)
    
  }
  
  @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
   self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue //of CGRect
    return keyboardSize.CGRectValue().height

  }
  
  func subscribeToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
  }
  
  func subscribeToKeyboardWillHideNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  
  func unsubscribeFromKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
  }
  
  func unsubscribeFromWillHideKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.dismissViewControllerAnimated(true, completion: nil)
    
  }
  
  
  @IBAction func pickAnImageFromCamera(sender: AnyObject) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
    self.presentViewController(imagePicker, animated: true, completion: nil)  }
  
  @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    self.presentViewController(imagePicker, animated: true, completion:nil)
  }
  
  func imagePickerController(picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
      shareButton.enabled = true
      self.dismissViewControllerAnimated(true, completion: nil)
      
      if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        self.imagePickerView.image = image
        self.imagePickerView.contentMode = UIViewContentMode.ScaleAspectFill
      }
  }
  
  func save() {
    //Create the meme
    var meme = Meme( topText: topText.text!, bottomText: bottomText.text!, originalImage:
      self.imagePickerView.image, memedImage: generateMemedImage())
    
    // Add it to the memes array on the Application Delegate
      (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
  }
  
  // Create a UIImage that combines the Image View and the Textfields
  func generateMemedImage() -> UIImage {
   
    // Hide toolbar and navbar
    hideToolbars(true)
    
    // render view to an image
    UIGraphicsBeginImageContext(self.view.frame.size)
    self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
    let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    // Show toolbar and navbar
    hideToolbars(false)
    
    return memedImage
  }
  
  func hideToolbars(flag: Bool) {
    
    navigationController?.navigationBarHidden = flag
    toolbar.hidden = flag
  }
  
}

