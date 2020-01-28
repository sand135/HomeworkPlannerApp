//
//  extensionUiView.swift
//  HomeWorkPlanner
//
//  Created by Sandra Sundqvist on 2019-03-26.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation
import UIKit


extension UIView{
    
    /**
     Sätter bakgrundsfärg på en vy beroende på ämne. 
    */
    func setBackgroundColorbyBy(subject: String?) {
        guard let subject = subject else{
            return
        }
        
        switch subject {
        case HomeWork.subjects.math.rawValue:
            self.backgroundColor = UIColor.init(named: "Iguana green")
        case HomeWork.subjects.english.rawValue:
            self.backgroundColor = UIColor.init(named: "yellow")
        case HomeWork.subjects.nature.rawValue:
            self.backgroundColor = UIColor.init(named: "limeGreen")
        case HomeWork.subjects.finish.rawValue:
            self.backgroundColor = UIColor.init(named: "turkose")
        case HomeWork.subjects.history.rawValue:
            self.backgroundColor = UIColor.init(named: "turkoseBlue")
        case HomeWork.subjects.PE.rawValue:
            self.backgroundColor = UIColor.init(named: "DArk tangerine")
        case  HomeWork.subjects.swedish.rawValue:
            self.backgroundColor = UIColor.init(named: "pink")
        case HomeWork.subjects.other.rawValue:
            self.backgroundColor = UIColor.init(named: "purple")
        default:
            self.backgroundColor = UIColor.init(named: "purple")
        }
    }
    
    /**
     skapar rundade hörn på vyn
     */
    func roundedCorners() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    
}
