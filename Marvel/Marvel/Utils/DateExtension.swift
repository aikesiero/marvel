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
}
