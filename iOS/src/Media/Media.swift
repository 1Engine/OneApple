//
//  Media.swift
//  r-ios
//
//  Created by R on 05.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

final public class Media {

    public static func videos() {
        
    }
    
    public static func photos() {
        
    }
    
    public static func media() {
    }
    
    public static func viewController(type: UIImagePickerController.SourceType) -> UIImagePickerController? {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let imagePickerController = UIImagePickerController()
            //imagePickerController.delegate = self
            imagePickerController.sourceType = type
            return imagePickerController
        }
        return nil
    }
}
