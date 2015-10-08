//
//  EditMemeViewController.swift
//  Meme Me
//
//  Created by Victor Guthrie on 9/29/15.
//  Copyright © 2015 Victor Guthrie. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditMemeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var memeTextTop: UITextField!
    @IBOutlet weak var memeTextBottom: UITextField!
    @IBOutlet weak var memeImage: UIImageView!
    
    @IBOutlet weak var getImageFromCameraButton: UIBarButtonItem!
    @IBOutlet weak var getImageFromAlbumButton: UIBarButtonItem!
    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    
    var activeMemeImage: UIImage?
    var activeTextField: UITextField?
    var imageRect: CGRect?
    
    var edited = false
    var viewShifted = false
    
    let kMemeTextMargin: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpTextFields()
        setUpActionButtons()
        resetMeme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setMemeImage()
        setMemeTextPositions()
    }
    
    
    @IBAction func getImageFromCamera(sender: UIBarButtonItem) {
        let cameraController = UIImagePickerController()
        cameraController.sourceType = UIImagePickerControllerSourceType.Camera
        cameraController.delegate = self
        
        let mediaTypes:[String] = [kUTTypeImage as NSString as String]
        cameraController.mediaTypes = mediaTypes
        
        presentViewController(cameraController, animated: true, completion: nil)
    }

    @IBAction func getImageFromPhotoAlbum(sender: UIBarButtonItem) {
        let photoLibraryController = UIImagePickerController()
        photoLibraryController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        photoLibraryController.delegate = self
        
        let mediaTypes:[String] = [kUTTypeImage as NSString as String]
        photoLibraryController.mediaTypes = mediaTypes
        
        presentViewController(photoLibraryController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let combinedImage: UIImage = getCombinedMemeImage()
        
        let activityVC = UIActivityViewController(activityItems: [combinedImage], applicationActivities: [])
        presentViewController(activityVC, animated: true, completion: {
            Void in
            let newMeme = Meme(textTop: self.memeTextTop!.text!, textBottom: self.memeTextBottom!.text!, image: self.memeImage!.image!, combinedImage: combinedImage)
            (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes.append(newMeme)
        })
    }
    
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        resetMeme()
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        activeMemeImage = image
        setMemeImage()
        setMemeTextPositions()
        shareMemeButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == memeTextTop && textField.text == "TOP" {
            textField.text = ""
        } else if textField == memeTextBottom && textField.text == "BOTTOM" {
            textField.text = ""
        }
        activeTextField = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        activeTextField = nil
        return true
    }
    
    /** triggered when keyboard is about to show,
        moves the view up if active text view is covered */
    func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = getKeyboardHeight(notification)
        var aRect : CGRect = view.frame
        aRect.size.height -= keyboardHeight
        if let activeTextField = activeTextField {
            if (!CGRectContainsPoint(aRect, activeTextField.frame.origin)) {
                view.frame.origin.y -= keyboardHeight
                viewShifted = true
            }
        }
        
    }
    
    /** triggered when keyboard is about to be hidden,
        moves the view down if it was previously moved up */
    func keyboardWillHide(notification: NSNotification) {
        if (viewShifted) {
            view.frame.origin.y = 0
            viewShifted = false
        }
    }
    
    // MARK: Helper Methods
    
    /** Sets up meme text styles */
    private func setUpTextFields(){
        let textAttributes = [
            NSFontAttributeName : UIFont(name:"HelveticaNeue-CondensedBlack", size: 40.0)!,
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -1.0
        ]
        
        memeTextTop.defaultTextAttributes = textAttributes
        memeTextTop.textAlignment = NSTextAlignment.Center
        memeTextTop.delegate = self
        
        memeTextBottom.defaultTextAttributes = textAttributes
        memeTextBottom.textAlignment = NSTextAlignment.Center
        memeTextBottom.delegate = self
    }
    
    /** Reset meme fields */
    private func resetMeme(){
        memeTextTop.text = "TOP"
        memeTextBottom.text = "BOTTOM"
        memeImage.image = nil
        activeMemeImage = nil
        imageRect = nil
        shareMemeButton.enabled = false
    }
    
    /** Sets up Action buttons based on available features */
    private func setUpActionButtons(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            getImageFromCameraButton.enabled = true
        } else {
            getImageFromCameraButton.enabled = false
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            getImageFromAlbumButton.enabled = true
        } else {
            getImageFromAlbumButton.enabled = false
        }
    }
    
    /** Determine the height of the keyboard */
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        memeTextBottom.touchInside
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    /** subscribes to necessary keyboard notiications */
    private func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /** unsubscribes to keyboard notiications */
    private func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /** get scaled image */
    private func setMemeImage() {
        if let image = activeMemeImage {
            let targetRect = memeImage.frame
            
            var width = targetRect.size.width
            var height = targetRect.size.height
            
            UIGraphicsBeginImageContext(targetRect.size);
            var rect = CGRectMake(0, 0, width, height);
            
            let widthRatio = image.size.width / width;
            let heightRatio = image.size.height / height;
            let divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
            
            width = image.size.width / divisor
            height = image.size.height / divisor
            
            rect.size.width  = width;
            rect.size.height = height;
    
            rect.origin.x = memeImage.frame.width/2 - width/2
            rect.origin.y = memeImage.frame.height/2 - height/2
            
            print("rect x: \(memeImage.frame.origin.x) y: \(memeImage.frame.origin.y)")
            
            image.drawInRect(rect)
            memeImage.image = UIGraphicsGetImageFromCurrentImageContext();
            imageRect = rect
            UIGraphicsEndImageContext();
        }
    }
    
    private func setMemeTextPositions() {
        if let imageRect = imageRect {
            print("x: \(imageRect.origin.x) y: \(imageRect.origin.y)")
            memeTextTop.frame.origin.y = topLayoutGuide.length + imageRect.origin.y + kMemeTextMargin
            memeTextBottom.frame.origin.y = topLayoutGuide.length + imageRect.origin.y + imageRect.height - memeTextBottom.frame.height - kMemeTextMargin
        } else {
            memeTextTop.frame.origin.y = topLayoutGuide.length + kMemeTextMargin
            memeTextBottom.frame.origin.y = view.frame.height - (navigationController?.toolbar.frame.height)! - kMemeTextMargin - memeTextBottom.frame.height
        }
        print("top-height: \(memeTextTop.frame.height) top-y: \(memeTextTop.frame.origin.y) bottom-y: \(memeTextBottom.frame.origin.y)")
    }
    
    /** get image combining meme image and text */
    private func getCombinedMemeImage() -> UIImage {
        UIGraphicsBeginImageContext(memeImage.frame.size)
        view.drawViewHierarchyInRect(memeImage.frame, afterScreenUpdates: true)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}

