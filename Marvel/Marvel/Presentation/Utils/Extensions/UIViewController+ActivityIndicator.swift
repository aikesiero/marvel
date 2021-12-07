//
//  UIViewController+ActivityIndicator.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 29/11/21.
//

import UIKit

extension UITableViewController {

    func makeActivityIndicator(size: CGSize) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        if self.traitCollection.userInterfaceStyle == .dark {
            activityIndicator.color = .white
        } else {
            activityIndicator.color = .gray
        }
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.frame = .init(origin: .zero, size: size)

        return activityIndicator
    }
}
