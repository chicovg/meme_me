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
    
    var activeMeme: Meme!
    var edited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpMemeText()
        setUpActionButtons()
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
    
    
    @IBAction func getImageFromCamera(sender: UIBarButtonItem) {
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = UIImagePickerControllerSourceType.Camera
        
        let mediaTypes:[String] = [kUTTypeImage as NSString as String]
        cameraController.mediaTypes = mediaTypes
        cameraController.allowsEditing = false
        
        self.presentViewController(cameraController, animated: true, completion: nil)
    }

    @IBAction func getImageFromPhotoAlbum(sender: UIBarButtonItem) {
        let photoLibraryController = UIImagePickerController()
        photoLibraryController.delegate = self
        photoLibraryController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        let mediaTypes:[String] = [kUTTypeImage as NSString as String]
        photoLibraryController.mediaTypes = mediaTypes
        photoLibraryController.allowsEditing = false
        
        self.presentViewController(photoLibraryController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        memeImage.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == memeTextTop && textField.text == "TOP" {
            textField.text = ""
        } else if textField == memeTextBottom && textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Helper Methods
    
    /* Sets up meme text styles */
    private func setUpMemeText(){
        let textAttributes = [
            NSFontAttributeName : UIFont(name:"HelveticaNeue-CondensedBlack", size: 40.0)!,
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -1.0,
        ]
        
        memeTextTop.text = "TOP"
        memeTextBottom.text = "BOTTOM"
        
        memeTextTop.defaultTextAttributes = textAttributes
        memeTextBottom.defaultTextAttributes = textAttributes
        
        memeTextTop.delegate = self
        memeTextBottom.delegate = self
    }
    
    /* Sets up Action buttons based on available features */
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
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    private func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    private func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
}

