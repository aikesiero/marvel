//
//  DateExtension.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 24/11/21.
//

import Foundation

extension Date {
    func toString() -> String {
        return Log.dateFormatter.string(from: self as Date)
    }

    func utcDateToString(withFormat format: String = "yyyy/MM/dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format

        let stringdate = dateFormatter.string(from: self)
        return stringdate
    }
}
