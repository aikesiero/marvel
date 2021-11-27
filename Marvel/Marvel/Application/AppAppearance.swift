//
//  AppAppearance.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 27/11/21.
//

import Foundation
import UIKit

final class AppAppearance {

    static func setupAppearance() {

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .mainColor

        guard let customFont = UIFont(name: "BentonSansExtraComp-Black", size: 30) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }

        appearance.titleTextAttributes = [.font: customFont,
                                          .foregroundColor: UIColor.lightTextColor ?? .white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

    }
}
