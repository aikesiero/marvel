//
//  String+Localized.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 27/11/21.
//

import Foundation

extension String {

    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
