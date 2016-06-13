//
//  textFieldDelegate.swift
//  imagePickerTutorial
//
//  Created by Maggie Moss on 2016-05-23.
//  Copyright © 2016 Maggie Moss. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        return true
        
        
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        // only want it to clear if the field has not been edited yet.
        textField.text = ""
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    func keyboardWillShow(notification: NSNotification){
//        self.view.frame.origin.y -= getKeyBoardHeight()
//    }
    
//    func getKeyBoardHeight(notification: NSNotification) -> CGFloat{
//        let userInfo = notification.userInfo
//        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
//        return keyboardSize.CGRectValue().height
//    }
//    
//    func subscribeToKeyBoardNotifications(){
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
//    }
}