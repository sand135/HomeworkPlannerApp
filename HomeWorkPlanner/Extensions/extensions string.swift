//
//  extensions string.swift
//  HomeWorkPlanner
//
//  Created by Sandra Sundqvist on 2019-03-21.
//  Copyright © 2019 Sandra Sundqvist. All rights reserved.
//

import Foundation

extension String{
    
    enum dateConverterException: Error {
        case dateCouldNotConvert
    }
    
    
    /**
     formaterar om en sträng i formatet "EEEE, d MMMM-yyyy" till ett date-object
    */
    func formatttedToDate() throws -> Date {
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        df.locale = Locale(identifier: LocalizationHelper.getLocalizationIdentifier())
        df.dateFormat = "EEEE, d MMMM-yyyy"
        
        guard let dateFromString: Date = df.date(from: self) else{
            throw dateConverterException.dateCouldNotConvert
        }
        return dateFromString
    }
}
