//
//  AppDelegate.swift
//  Marvel
//
//  Created by Aike Fernández Roza on 24/11/21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        AppAppearance.setupAppearance()

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()

        window?.rootViewController = navigationController

        appFlowCoordinator = AppFlowCoordinator(navigationController: navigationController,
                                                appDIContainer: appDIContainer)
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()

        return true
    }

}
