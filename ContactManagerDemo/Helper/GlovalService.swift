//
//  GlovalService.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 31.10.2020.
//

import UIKit

class GlobalService: NSObject {
    
    static func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
//    static func correctingImageURL(urlString: String) -> String {
//        var imageUrl = urlString.replacingOccurrences(of: "amp;", with: "", options: NSString.CompareOptions.literal, range: nil)
//        imageUrl = imageUrl.replacingOccurrences(of: "amp;s", with: "s", options: NSString.CompareOptions.literal, range: nil)
//        return imageUrl
//    }
}
extension UITableView {
    func registerCellFromNib(_ nameCell: String) -> Void{
        let nib = UINib(nibName: nameCell, bundle: nil)
        self.register(nib, forCellReuseIdentifier: nameCell)
    }
}
