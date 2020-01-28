//
//  extension Date.swift
//  HomeWorkPlanner
//
//  Created by Sandra Sundqvist on 2019-03-20.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation


extension Date {
    
    
    /**
     formaterar om ett datum till en sträng i formatet: EEEE, d MMMM-yyyy- med versal som första bokstaven i dagen
     och local svenska.
     */
    func formattedToString()->String{
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        df.locale = Locale(identifier: "swe")
        df.dateFormat = "EEEE, d MMMM-yyyy"
       
        //Skapar en sträng av datumet med versal som första bokstav på dagen
        return df.string(from: self).prefix(1).capitalized + df.string(from: self).dropFirst()
    }
    
    /**
     Returnerar ett datum ett dygn framåt
    */
    func oneDayAhead() -> Date {
        return self + 3600 * 24
    }
    
    /**
     Formaterar om ett datum till en sträng i formatet: d MMMM med versal som första bokstaven i dagen
     och local enligt appens Local i LocalHelper.
     */
    func formattedToDateOfDay() -> String {
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        df.locale = Locale(identifier: "swe")
        df.dateFormat = "d MMMM"
        
        return df.string(from: self)
    }
}
