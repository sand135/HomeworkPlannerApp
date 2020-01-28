//
//  HomeWorksTableViewCell.swift
//  HomeWorkPlanner
//
//  Created by Sandra Sundqvist on 2019-03-04.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit

class HomeWorksTableViewCell: UITableViewCell {

    
    @IBOutlet weak var HomeWorkTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dueDayAlertView: UIView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //gör rundade hörn på varje cell
        self.roundedCorners()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configureWith(homeworkObject: HomeWork) {
        HomeWorkTitleLabel.text = homeworkObject.subject
        self.setBackgroundColorbyBy(subject: homeworkObject.subject)
        self.configureDateLabelByDateOf(homeworkObject: homeworkObject)
    }
    

    
    private func configureDateLabelByDateOf(homeworkObject: HomeWork){

        let tomorrow = Date().oneDayAhead()
        if let homeWorkDate = try? homeworkObject.date.formatttedToDate(){
            if homeworkObject.date == tomorrow.formattedToString(){
                dateLabel.text = "Tills imorgon!"
                dateLabel.textColor = UIColor.red
                dueDayAlertView.backgroundColor = UIColor.red
                HomeWorkTitleLabel.textColor = UIColor.black
            }
            else if homeWorkDate <= Date(){
                self.backgroundColor = UIColor.lightGray
                dateLabel.text = "Skulle göras till \(homeworkObject.date) "
                dateLabel.textColor = UIColor.white
                HomeWorkTitleLabel.textColor = UIColor.white
                dueDayAlertView.backgroundColor = UIColor.lightGray
                }
            else{
                HomeWorkTitleLabel.textColor = UIColor.black
                dateLabel.text = homeworkObject.date
                dueDayAlertView.backgroundColor = self.backgroundColor
                dateLabel.textColor = UIColor.black
            }
        }
    
    }
}
