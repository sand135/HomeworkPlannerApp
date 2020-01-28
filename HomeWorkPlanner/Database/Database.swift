//
//  Database.swift
//  HomeWorkPlanner
//
//  Created by Sandra Sundqvist on 2019-03-04.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit
import Firebase


class Database: NSObject {
    
    private let db = Firestore.firestore()
    private static let database = Database()
    var delegate: DataDownloadDelegate?
    var dataArray = Array<HomeWork>()
    private var listenerForUpdates: ListenerRegistration?
    private let storage = Storage.storage()
    private let collectionName = "HomeWorks"
    
    
    static func getDatabaseInstance() -> Database {
        return database
    }

    override private init() {
        //Använd getDatabaseInstance istället för att använda initmetod och göra nya objekt
    }
    
    
    /**
     Laddar upp ett läxobjektet till firestore (utan bild)
     */
    func add(homework: HomeWork) {
        //sätter till ett nytt läxobjekt i firestore
        let newDictionaryObject = homework.convertObjectToDictionary()
        var ref:DocumentReference?
        ref = db.collection(self.collectionName).addDocument(data: newDictionaryObject) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    /**
      Laddar upp bilden till firebase storage och läxobjektet till firestore med bildens url och namn sparat
    */
    func add(newHomeWork: HomeWork, with image: UIImage, onCompletion: @escaping(Bool)->Void){
        self.upLoad(image: image) { (urlString, imageName) in
            newHomeWork.imageURL = urlString
            newHomeWork.imageName = imageName
            self.add(homework: newHomeWork)
            onCompletion(true)
        }
    }
    
    
    /**
     Raderar objektet och dess eventuella bild ur databasen
     */
    func deleteDocumentFor(object :HomeWork){
        if let iName = object.imageName{
            self.deletePictureWith(name: iName)
        }
        guard let identifier = object.id else{
            return
        }
        //Tar bort dokumentet med objectets id ur databasen
        db.collection(self.collectionName).document(identifier).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document with id \(identifier) successfully removed!")
            }
        }
    }
    
    /**
     Skapar en lyssnare för databasen som känner av om objekt läggs till (hämtar alla dokument första gången den körs), uppdateras eller tas bort i collection "homeworks"
     */
    func getDataAndRealtimeUpdates() {
       listenerForUpdates = db.collection("HomeWorks")
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    
                    if (diff.type == .added) {
                        print("New homework: \(diff.document.data())")
                        let addedHomework = HomeWork(initWithDictionary: diff.document.data())
                        addedHomework.id = diff.document.documentID
                        self.dataArray.append(addedHomework)
                    }
                    if (diff.type == .modified) {
                        print("Modified homework: \(diff.document.data())")
                        let changedHomework = HomeWork(initWithDictionary: diff.document.data())
                        changedHomework.id = diff.document.documentID
                        for homework in self.dataArray{
                            if(homework.id == changedHomework.id){
                                homework.updateObject(from: changedHomework)
                            }
                        }
                    }
                    if (diff.type == .removed) {
                        print("Removed homework: \(diff.document.data())")
                        let deletedHomework = HomeWork(initWithDictionary: diff.document.data())
                        deletedHomework.id = diff.document.documentID
                        for homework in self.dataArray{
                            if(homework.id == deletedHomework.id){
                             self.dataArray.removeAll(where: {$0 == homework})
                            }
                        }
                    }
                }
                self.didDownloadData()
        }
    }
    
    private func didDownloadData(){
        //Meddelar de klasser som "vill veta" att data har laddats ner
        delegate?.dataDidFinishDownloading()
    }
    
    func detachListener() {
        //Raderar lyssnaren för uppdateringar från databasen
        listenerForUpdates?.remove()
    }
    
    
    //MARK: Image uploading/downloading-Methods
    
    private func deletePictureWith(name: String) {
        //raderar bilden ur databasen
        let storageRef = storage.reference().child(name)
        storageRef.delete { (error) in
            if error != nil{
                print ("An error occured when trying to delete image with \(name)")
            }
            print("Image with name\(name) was successfully deleted!")
        }
    }
    
    /**
    Laddar upp bilden till firebase storage och när det är klart ger den tillbaka url för bilden och namnet på bilden
     */
    private func upLoad(image: UIImage, onCompletion: @escaping(_ url:String, _ name:String)->Void){
        //Skapar ett unikt namn för varje bild
        let uniqueImageId = NSUUID().uuidString
        let imagename = "\(uniqueImageId).png"
        
        //hämtar en referens till "databasutrymmet" och skapar ett "barn" där bilden kommer att sparas
        let storageRef = storage.reference().child(imagename)
        guard let imageAsPngData = image.pngData() else{return}
        
        storageRef.putData(imageAsPngData, metadata: nil) { (metadata, error) in
           if error != nil {
                    print(error as Any)
                    return
           }else{
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        return
                    }else{
                        if(url != nil){
                        onCompletion((url!.absoluteString), imagename)
                        }
                    }
                })
            }
                
        }
    }
    
}
