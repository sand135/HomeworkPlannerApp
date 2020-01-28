//
//  DetailViewController.swift
//  HomeWorkPlanner
//
//  Created by Sandra Sundqvist on 2019-03-13.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
   
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var yellowFishImageView: UIImageView!
    @IBOutlet weak var fischConstraintForXPosition: NSLayoutConstraint!
    @IBOutlet weak var subjectTitleLabel: UILabel!
    @IBOutlet weak var HomeWorkDescriptionLabel: UILabel!
    @IBOutlet weak var homeWorkImageView: UIImageView!
    @IBOutlet weak var dueDateLabel: UILabel!
    var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    self.startTimer()
    self.configureWith(selectedHW: HomeWorkHelper.homeWorkObject)
    }

    
    
    
    func configureWith(selectedHW: HomeWork?) {
        if let subject = selectedHW?.subject{
            subjectTitleLabel.text = subject
            subjectTitleLabel.setBackgroundColorbyBy(subject: subject)
            subjectTitleLabel.roundedCorners()
        }
        
        if let value = selectedHW?.value{
            HomeWorkDescriptionLabel.text = value
        }
        
        if let date = selectedHW?.date{
            if(date == Date().oneDayAhead().formattedToString()){
                self.dueDateLabel.text = "Imorgon!"
                self.dueDateLabel.textColor = UIColor.red
            }else{
                 self.dueDateLabel.text = date
            }
        }
        
        if let imageUrl = selectedHW?.imageURL{
            self.activityIndicator.startAnimating()
            guard let url = URL(string: imageUrl) else{
                self.activityIndicator.stopAnimating()
                return
            }
            ImageLoader.loadPictureFrom(url: url, into: homeWorkImageView) { (true) in
            self.activityIndicator.stopAnimating()
           }
        }
    }
    

    func startTimer() {
    self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(fireFish), userInfo: nil, repeats: true)
    }
    
    
    @objc func fireFish() {
        //Animerar fiskens rörelse. Flyttar den mot vänster varje gång timern "avfyras"
        if(self.fischConstraintForXPosition.constant > -500){
            self.yellowFishImageView.isHidden = false
            self.fischConstraintForXPosition.constant -= 10
        }
        else{
            //när fisken kommer över -500 göms den och åker tillbaka
            self.yellowFishImageView.isHidden = true
            self.fischConstraintForXPosition.constant = 500
        }
       
    }
    
  
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
       //Stänger av timern innan vyn försvinner
        timer?.invalidate()
        self.navigationController?.popViewController(animated: true)
    }

}
