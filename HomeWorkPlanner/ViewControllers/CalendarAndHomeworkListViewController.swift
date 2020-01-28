//
//  CalendarAndHomeworkListViewController.swift
//  HomeWorkPlanner
//
//  Created by Sandra Sundqvist on 2019-03-08.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarAndHomeworkListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataDownloadDelegate, FSCalendarDelegate, FSCalendarDataSource {
    

    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var foldUnFoldButton: UIButton!
    @IBOutlet weak var calenderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var HomeWorkListTableView: UITableView!
    var db: Database?
    var selectedDateInCalendar = Date().oneDayAhead()
    var sortedList = Array<HomeWork>()
    var showingAll = false
    let radiusForCorners = 10
    var sortedLisWithDatesForTomorrow = Array<HomeWork>()
    

    
    //MARK: ViewLoadingMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.HomeWorkListTableView.delegate = self
        self.HomeWorkListTableView.dataSource = self
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.HomeWorkListTableView.roundedCorners()
        self.calendar.roundedCorners()

        db = Database.getDatabaseInstance()
        self.db?.delegate = self
        //hämtar allt från databasen och skapar en listener för uppdateringar
        db?.getDataAndRealtimeUpdates()
        
        //Sätter defaultvyn för kalendern till vecka, sätter språket för den och markerar dagen efter nuvarande dag för att visa läxor för nästa dag by default
        self.calendar.scope = .week
        self.calendar.locale = Locale(identifier: LocalizationHelper.getLocalizationIdentifier())
        let tomorrow = Date().oneDayAhead()
        self.calendar.select(tomorrow)
        
        //Skapar en local notifikation till klockan 17 varje dag
        let localNH = NotificationHelper()
        localNH.addLocalNotificationAtClockTime(hour: 17, minutes: 00, ShouldRepeat: true)
        self.HomeWorkListTableView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
       //Avmarkera ett eventuellt "påklickat" objekt i listan
        if(HomeWorkListTableView.indexPathForSelectedRow != nil){
        HomeWorkListTableView.deselectRow(at: HomeWorkListTableView.indexPathForSelectedRow!, animated: true)
        }
        
    }

    
    func dataDidFinishDownloading() {
        self.setList()
    }
    
    func setList() {
        sortedList.removeAll()
        guard let allData = self.db?.dataArray else {
            return
        }
        
        if(showingAll){
            sortedList = sort(list: allData)
        }else{
            for item in allData{
                if item.date == selectedDateInCalendar.formattedToString(){
                    sortedList.append(item)
                }
            }
        }
        self.HomeWorkListTableView.reloadData()
    }
    
 
    //MARK: TableViewMethods
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           headerView.backgroundColor = UIColor.clear
           return headerView
       }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            let selectedHW = sortedList[indexPath.section]
            db?.deleteDocumentFor(object: selectedHW) 
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Radera") { (action, indexPath) in
            self.HomeWorkListTableView.dataSource?.tableView!(self.HomeWorkListTableView, commit: .delete, forRowAt: indexPath)
            return
        }
        return [deleteButton]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HWCell", for: indexPath) as! HomeWorksTableViewCell
        cell.configureWith(homeworkObject: sortedList[indexPath.section])
        return cell
    }
    
    //MARK: CalendarMethods
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calenderHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.showingAll = false
        selectedDateInCalendar = date
        self.setList()
    }
    
    //MARK: SegueMethods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "detailSegue"){            
            HomeWorkHelper.homeWorkObject = sortedList[self.HomeWorkListTableView.indexPathForSelectedRow?.section ?? 0]
        }else if (segue.identifier == "addSegue"){
                AddEditHelper.selectedDate = selectedDateInCalendar
        }
    }
    
    
    @IBAction func foldUnFoldButtonPressed(_ sender: UIButton) {
        //Sätter kalendern i vecko eller i månadsläge
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
            self.foldUnFoldButton.setImage(UIImage(named: "unfold_button"), for: .normal)
        } else {
            self.calendar.setScope(.month, animated: true)
            self.foldUnFoldButton.setImage(UIImage(named: "fold_button"), for: .normal)
        }
    }
    
    
    @IBAction func AllButtonPressed(_ sender: Any) {
        self.sortedList.removeAll()
        guard let allItemList = self.db?.dataArray else{
            return
        }
        self.sortedList = sort(list: allItemList)
        HomeWorkListTableView.reloadData()
        self.showingAll = true
    }
    
    func sort(list: [HomeWork]) -> [HomeWork] {
       //Sorterar listan enligt datum från äldre till nyare
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        df.locale = Locale(identifier: LocalizationHelper.getLocalizationIdentifier())
        df.dateFormat = "EEEE, d MMMM-yyyy"
        
        return list.sorted(by: { (df.date(from: $0.date)!  <  df.date(from: $1.date)!) })
    }
    
}
