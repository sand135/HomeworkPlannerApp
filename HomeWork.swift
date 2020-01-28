//
//  HomeWork.swift
//  
//
//  Created by Sandra Sundqvist on 2019-03-04.
//

import UIKit

class HomeWork: NSObject {
    
    enum subjects:String {
        case math = "Matematik"
        case english = "Engelska"
        case history = "Historia"
        case swedish = "Svenska"
        case PE = "Gymnastik"
        case nature = "Omgivningslära"
        case finish = "Finska"
        case other = "Övrigt"
    }
    
    var id: String?
    var subject: String?
    var value: String?
    var date: String
    var imageURL: String?
    var imageName: String?
    
    
    init(withSubject subject: String, value: String, andDate date: String ) {
        self.subject = subject
        self.value = value
        self.date = date
    }

    init(initWithDictionary dictionary: [String:Any]) {
        self.subject = dictionary["subject"] as? String
        self.value = dictionary["value"] as? String
        self.id = dictionary["id"] as? String
        self.date = dictionary ["date"] as? String ?? Date().formattedToString()
        self.imageURL = dictionary["imageUrl"] as? String
        self.imageName = dictionary["imageName"] as? String
    }
    
    func convertObjectToDictionary() -> [String:Any] {
        
        var dictionaryObject = [String:Any]()
        
        dictionaryObject["subject"] = self.subject as Any
        dictionaryObject["value"] = self.value as Any
        dictionaryObject["id"] = self.id as Any
        dictionaryObject["date"] = self.date as Any
        dictionaryObject["imageUrl"] = self.imageURL as Any
        dictionaryObject["imageName"] = self.imageName as Any
        return dictionaryObject
    }
    
    
    func updateObject(from changedHomework: HomeWork) {
        self.subject = changedHomework.subject
        self.value = changedHomework.value
        self.date = changedHomework.date
    }

}
