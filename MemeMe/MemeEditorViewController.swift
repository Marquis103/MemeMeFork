//
//  ViewController.swift
//  MemeMe
//
//  Created by Marquis Dennis on 1/31/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

  //MARK: Properties
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var toolbar: UIToolbar!
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var shareButton: UIBarButtonItem!
  
  var meme:Meme?
  
  let memeTextAttributes = [
    NSStrokeColorAttributeName : UIColor.blackColor(),
    NSForegroundColorAttributeName : UIColor.whiteColor(),
    NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName : -3.0
  ]
  
  struct KeyboardLayOut {
    static var keyboardOrientation:UIDeviceOrientation?
    static var keyboardHeight:CGFloat?
  }
  
  //MARK: Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpTextFields()
    
    //subscribe to keyboard will show notification
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func keyboardWillShow(notification:NSNotification) {
    if bottomTextField.isFirstResponder() {
      let userInfo = notification.userInfo
      let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
      self.view.frame.origin.y -= keyboardSize.CGRectValue().height
    }
    
  }
  
  func keyboardWillHide(notification:NSNotification) {
    if bottomTextField.isFirstResponder() {
      let userInfo = notification.userInfo
      let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
      view.frame.origin.y += keyboardSize.CGRectValue().height
    }
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func setUpTextFields() {
    
    topTextField.defaultTextAttributes = memeTextAttributes
    bottomTextField.defaultTextAttributes = memeTextAttributes
    
    topTextField.textAlignment = .Center
    bottomTextField.textAlignment = .Center
    
    topTextField.text = "TOP"
    bottomTextField.text = "BOTTOM"
    
    topTextField.delegate = self
    bottomTextField.delegate = self
    
  }
  
  func generateMemedImage() -> UIImage {
    
    toolbar.hidden = true
    navigationBar.hidden = true
    
    // Render view to an image
    UIGraphicsBeginImageContext(self.view.frame.size)
    view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
    let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    navigationBar.hidden = false
    toolbar.hidden = false
    
    return memedImage
  }
  
  override func viewWillAppear(animated: Bool) {
    cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
    
    shareButton.enabled = (imageView.image != nil)
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    view.endEditing(true)
  }
  
  //MARK: Actions
  
  @IBAction func cancelMemeEditing(sender: UIBarButtonItem) {
    imageView.image = nil
    topTextField.text = "TOP"
    bottomTextField.text = "BOTTOM"
    shareButton.enabled = false
  }
  
  @IBAction func pickAnImage(sender: AnyObject) {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .PhotoLibrary
    self.presentViewController(picker, animated: true, completion: nil)
  }

  @IBAction func shareImage(sender: UIBarButtonItem) {
    meme = Meme(topText: topTextField.text ?? "", bottomText: bottomTextField.text ?? "", originalImage: imageView.image!, memedImage: generateMemedImage())
    
    let activityView = UIActivityViewController(activityItems: [(meme?.memedImage)!], applicationActivities: nil)
    presentViewController(activityView, animated: true, completion: nil)
    
  }
  @IBAction func useCamera(sender: UIBarButtonItem) {
    let camera = UIImagePickerController()
    camera.delegate = self
    
    camera.sourceType = .Camera
    
    self.presentViewController(camera, animated: true, completion: nil)
  }
}

extension String {
  static func Empty() -> String {
    return ""
  }
}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      imageView.image = image
      imageView.contentMode = .ScaleToFill
      
      shareButton.enabled = (imageView.image != nil)
    }
    
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}

extension MemeEditorViewController : UITextFieldDelegate {
  func textFieldDidBeginEditing(textField: UITextField) {
    if textField.text == "TOP" || textField.text == "BOTTOM" {
        textField.text = String.Empty()
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
