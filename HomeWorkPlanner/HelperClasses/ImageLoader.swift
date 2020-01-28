//
//  ExtensionImageView.swift
//  HomeWorkPlanner
//
//  Created by Sandra Sundqvist on 2019-03-23.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class ImageLoader{
        
    
   static func loadPictureFrom(url: URL, into imageView: UIImageView, onCompletion: @escaping(Bool)->Void){
        //uses cocpod PinRemotImage to load and cache images from url
        //imageView.pin_setImage(from: url)
    imageView.pin_setImage(from: url) { (PINRemoteImageManagerResult) in
        onCompletion(true)
    }
    
    }
}
