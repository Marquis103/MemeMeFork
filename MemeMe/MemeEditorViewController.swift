//
//  ViewController.swift
//  MemeMe
//
//  Created by Marquis Dennis on 1/31/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class MemeEditorViewController: UIViewController {
	
	//MARK: Properties
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var bottomTextField: UITextField!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var toolbar: UIToolbar!
	@IBOutlet weak var navigationBar: UINavigationBar!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	
	var topTextFieldNSConstraint:NSLayoutConstraint!
	var bottomTextFieldNSConstraint:NSLayoutConstraint!
	
	var imageSize:CGSize!
	var imageFrame:CGRect!
	
	//core datastack implementation
	lazy var coreDataStack = CoreDataStack()
	
	//CGSize is used to create a meme icon image for tableview and colletionview cells
	var imageIconSize = CGSize(width: 90, height: 90)
	
	//variable is used to work around an issue where UIKeyboardWillShow notification is fired multiple times in a row
	var isLastNotificationKeyboardShow:Bool = false
	
	let memeTextAttributes = [
		NSStrokeColorAttributeName : UIColor.blackColor(),
		NSForegroundColorAttributeName : UIColor.whiteColor(),
		NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
		NSStrokeWidthAttributeName : -3.0
	]
	
	//MARK: Functions
	override func viewDidLayoutSubviews() {

		super.viewDidLayoutSubviews()
		
		layoutTextFields()
	}
	
	func layoutTextFields() {
		if let topTextFieldNSConstraint = topTextFieldNSConstraint {
			view.removeConstraint(topTextFieldNSConstraint)
		}
		
		if let bottomTextFieldNSConstraint = bottomTextFieldNSConstraint {
			view.removeConstraint(bottomTextFieldNSConstraint)
		}
		
		//get psotion of the image after aspect ratio
		if let selectedImage = imageView.image {
			imageSize = selectedImage.size ?? imageView.frame.size
			imageFrame = AVMakeRectWithAspectRatioInsideRect(imageSize, imageView.bounds)
			
			let margin = imageFrame.origin.y + imageFrame.size.height * 0.10
			
			topTextFieldNSConstraint = NSLayoutConstraint(item: topTextField, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .Top, multiplier: 1, constant: margin)
			view.addConstraint(topTextFieldNSConstraint)
			
			bottomTextFieldNSConstraint = NSLayoutConstraint(item: bottomTextField, attribute: .Bottom, relatedBy: .Equal, toItem: imageView, attribute: .Bottom, multiplier: 1, constant: -margin)
			view.addConstraint(bottomTextFieldNSConstraint)
			
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setUpTextFields()
		
	}
	
	func keyboardWillShow(notification:NSNotification) {
		if bottomTextField.isFirstResponder() && !isLastNotificationKeyboardShow {
			let userInfo = notification.userInfo
			let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
			view.frame.origin.y -= keyboardSize.CGRectValue().height
			
			isLastNotificationKeyboardShow  = true
		}
	}
	
	func keyboardWillHide(notification:NSNotification) {
		if bottomTextField.isFirstResponder() {
			view.frame.origin.y = 0
			
			isLastNotificationKeyboardShow = false
		}
	}
	
	func setUpTextFields() {
		
		topTextField.defaultTextAttributes = memeTextAttributes
		bottomTextField.defaultTextAttributes = memeTextAttributes
		
		topTextField.textAlignment = .Center
		bottomTextField.textAlignment = .Center
		
		topTextField.text = "TOP"
		bottomTextField.text = "BOTTOM"
		
		topTextField.hidden = true
		bottomTextField.hidden = true
		
		topTextField.delegate = self
		bottomTextField.delegate = self
		
	}
	
	func generateMemedImage() -> UIImage? {
		
		toolbar.hidden = true
		navigationBar.hidden = true
		
		// Render view to an image
		if let _ = imageView.image {
			UIGraphicsBeginImageContext(imageFrame.size)
			
			view.drawViewHierarchyInRect(CGRect(x: -imageFrame.origin.x, y: -imageFrame.origin.y, width: imageView.bounds.width, height: imageView.bounds.height), afterScreenUpdates: true)
			
			let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			return memedImage
		}
		
		navigationBar.hidden = false
		toolbar.hidden = false
		
		return nil
	}
	
	func saveModel(meme: Meme) {
		let memeModel = MemeModel(entity: coreDataStack.memeEntity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
		
		memeModel.topText = meme.topText
		memeModel.bottomText = meme.bottomText
		memeModel.originalImage = meme.originalImage
		memeModel.memedImage = meme.memedImage
		memeModel.memedImageIcon = UIImage.resizeImage(meme.memedImage, newSize: imageIconSize)
		
		coreDataStack.saveMainContext()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		
		//subscribe to keyboard will show notification
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
		
		cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
		
		shareButton.enabled = (imageView.image != nil)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(true)
		
		NSNotificationCenter.defaultCenter().removeObserver(self)
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
		
		topTextField.hidden = false
		bottomTextField.hidden = false
		
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func pickAnImage(sender: AnyObject) {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.sourceType = .PhotoLibrary
		presentViewController(picker, animated: true, completion: nil)
	}
	
	@IBAction func shareImage(sender: UIBarButtonItem) {

		let memedImage = generateMemedImage()
		
		if let memedImage = memedImage {
			let activityView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
			activityView.completionWithItemsHandler = {(activityType:String?, completed:Bool, returnedItems:[AnyObject]?, error:NSError?) in
				if !completed {
					self.dismissViewControllerAnimated(true, completion: nil)
				}
				
				//save meme
				let meme = Meme(topText: self.topTextField.text ?? "", bottomText: self.bottomTextField.text ?? "", originalImage: self.imageView.image!, memedImage: memedImage)
				self.saveModel(meme)
				
				self.dismissViewControllerAnimated(true, completion: nil)
			}
			
			presentViewController(activityView, animated: true, completion: nil)
		} else {
			let alertController = UIAlertController(title: "Meme Error", message: "Could not generate meme image!", preferredStyle: .Alert)
			let alertAction = UIAlertAction(title: "OK'", style: .Default, handler: nil)
			alertController.addAction(alertAction)
			
			presentViewController(alertController, animated: true, completion: nil)
		}
	}
	
	@IBAction func useCamera(sender: UIBarButtonItem) {
		let camera = UIImagePickerController()
		camera.delegate = self
		
		camera.sourceType = .Camera
		
		presentViewController(camera, animated: true, completion: nil)
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
			imageView.contentMode = .ScaleAspectFit
			imageView.image = image
			
			topTextField.hidden = false
			bottomTextField.hidden = false
			
			shareButton.enabled = (imageView.image != nil)
		}
		
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
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
	
	func textFieldDidEndEditing(textField: UITextField) {
		if let text = textField.text {
			textField.text = text.uppercaseString
		}
	}
}

extension UIImage {
	static func resizeImage(image: UIImage, newSize: CGSize) -> (UIImage) {
		let newRect = CGRectIntegral(CGRectMake(0,0, newSize.width, newSize.height))
		let imageRef = image.CGImage
		
		UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
		let context = UIGraphicsGetCurrentContext()
		
		// Set the quality level to use when rescaling
		CGContextSetInterpolationQuality(context, CGInterpolationQuality.High)
		let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
		
		CGContextConcatCTM(context, flipVertical)
		
		// Draw into the context; this scales the image
		CGContextDrawImage(context, newRect, imageRef)
		
		let newImageRef = CGBitmapContextCreateImage(context)!// as CGImage
		let newImage = UIImage(CGImage: newImageRef)
		
		// Get the resized image from the context and a UIImage
		UIGraphicsEndImageContext()
		
		return newImage
	}
}
