//
//  LocalNotificationHelper.swift
//  HomeWorkPlanner
//
//  Created by Sandra Sundqvist on 2019-03-25.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationHelper: NSObject, UNUserNotificationCenterDelegate{
    
    let notificationtitle = "Kom ihåg läxorna!"
    let notificationBody = "Gå in i appen och se om du ännu har något kvar att göra. Kämpa på! "
    let notificationIdentifier = "HWReminder"
    
    func addLocalNotificationAtClockTime(hour: Int, minutes: Int, ShouldRepeat: Bool) {
        
        self.requestForPermission { (didAllowRequest) in
            if !didAllowRequest{
                return
            }
            
            let content = UNMutableNotificationContent()
            
            content.title = self.notificationtitle
            content.body = self.notificationBody
            content.sound = UNNotificationSound.defaultCritical
            content.badge = 1
            
            var date = DateComponents()
            date.hour = hour
            date.minute = minutes
           
           let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: ShouldRepeat)
    
            //Sparar ner förfrågan om en notifikation enligt vad som ska trigga den
            let request = UNNotificationRequest(identifier: self.notificationIdentifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().delegate = self
            //Sätter till förfrågan om notifikationen i notificationcenter
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    private func requestForPermission(onCompletion:@escaping(Bool)->Void){
        //Ber om lov av användaren att skicka notifikationer
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
            if didAllow{
                onCompletion(true)
            }else{
                onCompletion(false)
            }
        })
    }
    
}
