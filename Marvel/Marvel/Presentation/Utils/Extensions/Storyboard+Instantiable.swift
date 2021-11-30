//
//  Storyboard+Instantiable.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 29/11/21.
//

import UIKit

public protocol StoryboardInstantiable: NSObjectProtocol {
    associatedtype TYPE
    static var defaultFileName: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> TYPE
}

public extension StoryboardInstantiable where Self: UIViewController {
    static var defaultFileName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }

    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let fileName = defaultFileName
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {

            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard with name \(fileName)")
        }
        return viewController
    }
}
