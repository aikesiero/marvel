//
//  UIViewController+Instantiable.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 26/11/21.
//

import UIKit

extension UIViewController {
    static func instantiate() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }

}
