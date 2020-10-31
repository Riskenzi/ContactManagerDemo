//
//  Navigation.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 31.10.2020.
//

import Foundation
import UIKit
class Navigation: NSObject {
    // MARK: - Helpers
    
    static func getRootViewController() -> UIViewController? {
        var rootViewController: UIViewController?
        if #available(iOS 13.0, *) {
            // iOS 13 (or newer) Swift code
            rootViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        } else {
            // iOS older code
            rootViewController = UIApplication.shared.keyWindow?.rootViewController
        }
        
        return rootViewController
    }
    
    public static func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        
        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }
        
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }
        
        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }
        
        return rootViewController
    }
    
    static func navigateFullScreen(in navigationController: UINavigationController,_ data : ContactModel? = nil) -> Void {
        DispatchQueue.main.async {
            let controller = DetailController(nibName: UINib.detailController, bundle: nil)
            controller.modalPresentationStyle = .fullScreen
            if let dataValid = data {
                //controller.delegate.model = DetailViewModel(data: dataValid)
                controller.model = DetailViewModel(data: dataValid)
            }
            navigationController.show(controller, sender: nil)
        }
    }
}
