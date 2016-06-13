//
//  ViewController.swift
//  imagePickerTutorial
//
//  Created by Maggie Moss on 2016-05-22.
//  Copyright © 2016 Maggie Moss. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    
    // QUESTIONS/TO DO
    // why is the color of the font not white?
    // why is it not centered
    // images appear pretty zoomed in
    // Is there a way to separate this out into separate files
    // How do I show line numbers along the side?
    // What is the proper syntax for the completion handler (Activity View)
    let fontAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
        NSStrokeWidthAttributeName: "4.0"
    ]
    override func viewDidLoad() {
        
        super.viewDidLoad()
        subscribeToKeyBoardNotifications()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        topText.text = "TOP"
        topText.textAlignment = NSTextAlignment.Center
        topText.adjustsFontSizeToFitWidth = true
        topText.defaultTextAttributes = self.fontAttributes
        topText.autocapitalizationType = .AllCharacters
        topText.delegate = self
       
        
        bottomText.textAlignment = NSTextAlignment.Center
        bottomText.textColor = UIColor.whiteColor()
        bottomText.defaultTextAttributes = self.fontAttributes
        bottomText.autocapitalizationType = .AllCharacters
        bottomText.text = "BOTTOM"
        bottomText.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        bottomText.defaultTextAttributes = self.fontAttributes
    }
    
    override func viewWillDisappear(animated: Bool) {
         unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated:true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // TEXT FIELD DELEGATE CODE
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        textField.textAlignment = NSTextAlignment.Center
        textField.defaultTextAttributes = fontAttributes
        return true
        
        
    }
    func textFieldDidBeginEditing(textField: UITextField) {
       
        // only want it to clear if the field has not been edited yet - check for default text
        // QUESTION: Is there a more efficient way of doing this? Placeholders?
        if let currentText = textField.text {
            if currentText == "TOP" || currentText == "BOTTOM" {
                textField.text = ""
            }
        } else {
            textField.text = ""
            // don't do anything?
        }

    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MOVING KEYBOARD UP AND DOWN
    func keyboardWillShow(notification: NSNotification){
       
        // only move up if the bottom field is being edited
        if(bottomText.editing){
            self.view.frame.origin.y -= getKeyBoardHeight(notification)
        }
    }
    
    func getKeyBoardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyBoardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y = 0
    }
    
    // CREATING & SAVING IMAGE
    
    struct Meme {
        var top: String
        var bottom: String
        var originalImage: UIImage
        var memedImage: UIImage
        init(top: String, bottom: String, originalImage: UIImage, memedImage: UIImage) {
            self.top = top
            self.originalImage = originalImage
            self.bottom = bottom
            self.memedImage = memedImage
        }
    }
    
    func save(){
        // create the meme
        let memedImage = generateMemedImage()
        _ = Meme(top: topText.text!, bottom: bottomText.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar       
        
        return memedImage
    }

   // SHARE IMAGE
    
    @IBAction func share(sender: AnyObject) {
        // TO DO - make sure users can only share completed memes
        let memeImage = generateMemedImage()
        // 1) LAUNCH ACTIVITY VIEW
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil )
        

        
//        activityViewController.completionWithItemsHandler = (string)
//        print(completionHander)
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
}

