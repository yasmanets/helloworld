//
//  DateProvider.swift
//  hello-world
//
//  Created by Yaser El Dabete Arribas on 5/5/22.
//

import Foundation

class DateProvider {
    /**
        Converts a date to the format indicated by parameter.
        - Parameter from: Initial date format.
        - Parameter to: Format to convert to
        - Parameter dateToConvert: Date to convert :).
     */
    func transformDate(from: String, to: String, dateToConvert: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = from
        if let date = dateFormatter.date(from: dateToConvert) {
            dateFormatter.dateFormat = to
            let stringDate = dateFormatter.string(from: date)
            return stringDate
        }
        return nil
    }
}
