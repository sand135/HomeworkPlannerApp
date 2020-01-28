//
//  AddEditViewController.swift
//  HomeWorkPlanner
//
//  Created by Sandra Sundqvist on 2019-03-14.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit
import FSCalendar

class AddEditViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, FSCalendarDelegate, FSCalendarDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpViewXConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var homeWorkEditTextField: UITextView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var homeWorkImageView: UIImageView!
    var subjectArray = [String]()
    var selectedSubject: String?
    
    
    @IBOutlet weak var dayAndDateButton: UIButton!
    
    //MARK:- ViewLoadingMethods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.calendar.delegate = self
        self.calendar.dataSource = self
    
        self.calendar.roundedCorners()
        self.homeWorkEditTextField.roundedCorners()
        self.popUpView.roundedCorners()
        
        //Göm kalenderPopupvyn vid uppstart
        popUpViewXConstraint.constant = -1000
        
        self.calendar.locale = Locale(identifier: LocalizationHelper.getLocalizationIdentifier())
        
        self.subjectArray = ["...",
                             HomeWork.subjects.english.rawValue,
                             HomeWork.subjects.history.rawValue,
                             HomeWork.subjects.swedish.rawValue,
                             HomeWork.subjects.finish.rawValue,
                             HomeWork.subjects.PE.rawValue,
                             HomeWork.subjects.math.rawValue,
                             HomeWork.subjects.nature.rawValue,
                             HomeWork.subjects.other.rawValue]
        
   
    self.dayAndDateButton.setTitle(AddEditHelper.selectedDate?.formattedToString(), for: .normal)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
   
   

    //MARK: Pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return subjectArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjectArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSubject = subjectArray[row]
        homeWorkEditTextField.setBackgroundColorbyBy(subject: selectedSubject)
        navigationController?.navigationBar.barTintColor = homeWorkEditTextField.backgroundColor
    }
    
    
    //MARK: Calendar-Methods
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.dayAndDateButton.setTitle(date.formattedToString(), for: .normal)
    }
    
    //MARK: - buttons
    @IBAction func DoneButtonPressed(_ sender: UIBarButtonItem) {
        let db = Database.getDatabaseInstance()
       
        
        self.activityIndicator.startAnimating()
        //Sätter till ett nytt läxobjekt till databasen
        if(selectedSubject != nil && selectedSubject != "..."){
            let newHomeWork = HomeWork(withSubject: selectedSubject!, value: homeWorkEditTextField.text, andDate: dayAndDateButton.titleLabel?.text ?? Date().oneDayAhead().formattedToString())
            
                if let image = homeWorkImageView.image{
                    db.add(newHomeWork: newHomeWork, with: image) { (didcomplete) in
                        if(didcomplete){
                           self.stopActivityIndicatorAndreturnFromVieController()
                        }else{
                            print("Something went wrong")
                        }
                    }
                } else{
                    db.add(homework: newHomeWork)
                    self.stopActivityIndicatorAndreturnFromVieController()
                }
            
        }else{
            //Ämnet kan inte vara tomt-isåfall visas ett varningsmeddelande
            self.showToast(message: "Välj ett ämne!")
            self.activityIndicator.stopAnimating()
        }
    }
    
   
    func stopActivityIndicatorAndreturnFromVieController() {
        self.activityIndicator.stopAnimating()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dayAndDateButtonPressed(_ sender: UIButton) {
        //Visar popupkalendern
        popUpViewXConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        //göm popupkalendern
        popUpViewXConstraint.constant = -1000
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func addPictureButtonPressed(_ sender: UIButton) {
       let imagePickerController = UIImagePickerController()
       imagePickerController.delegate = self
       self.addSwedishCameraActionPopupFor(imagePickerController: imagePickerController)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Vad som händer när pickern lyckats hämta en bild
        let image = info[.originalImage] as! UIImage
        homeWorkImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       //Vad som händer när Imagepickern har försökt hämta men avbryts
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func BackButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
