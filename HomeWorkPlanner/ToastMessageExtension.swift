//
//  ToastMessageExtension.swift
//  
//
//  Created by Sandra Sundqvist on 2019-03-14.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    
    func showToast(message : String) {
        //Skapar ett toastmeddelande
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.white
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Arial", size: 14.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 1.0, delay: 0.3, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func addSwedishCameraActionPopupFor(imagePickerController: UIImagePickerController) {
        let actionPopUp = UIAlertController(title: "Välj bild från:", message:"", preferredStyle: .actionSheet)
        actionPopUp.addAction(UIAlertAction(title: "Kamera", style: .default, handler: { (action: UIAlertAction) in
            //Kollar om det finns en tillgänglig kamera
            if(UIImagePickerController.isSourceTypeAvailable(.camera)){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                self.showToast(message: "Camera is not available")
            }
        }))
        
        actionPopUp.addAction(UIAlertAction(title: "Fotobiblioteket", style: .default, handler: { (action: UIAlertAction) in
            //Hämtar bild från bildbiblioteket
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        //Sätter till en "Cancel" knapp som endast återvänder till föregående vy
        actionPopUp.addAction(UIAlertAction(title: "Tillbaka", style: .cancel, handler: nil))
        self.present(actionPopUp, animated: true, completion: nil)
    }
    
    
}

