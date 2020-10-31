//
//  AlertService.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 30.10.2020.
//

import UIKit

class AlertService {
    func alert(_ message : String) -> Void {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        guard let rootVC = Navigation.getRootViewController(),
              let visableController = Navigation.getVisibleViewController(rootVC) else {
            print("🤷🏼‍♀️ Root ViewController or VisableController didn't found.")
            return
        }
        visableController.present(alert, animated: true, completion: nil)
    }
}
