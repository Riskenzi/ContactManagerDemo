//
//  LoadingImageView.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 30.10.2020.
//

import UIKit


let imageCacheItems = NSCache<AnyObject, AnyObject>()

class LoadingImageView: UIImageView {
    
    var task : URLSessionTask!
    let loader = UIActivityIndicatorView(style: .medium)
    
    func loadImage(from url: String) {
        
        guard let url = URL(string: url) else { return }
        
        image = nil
        
        addLoader()
        
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = imageCacheItems.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            self.removeLoader()
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { (data,response,error) in
            
           
            
            guard let data = data,
                  let newImage = UIImage(data: data) else {
                return
            }
            imageCacheItems.setObject(newImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.isHidden = false
                self.image = newImage
                self.loader.stopAnimating()
            }
        }
        task.resume()
    }

    func addLoader()-> Void {
        addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loader.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loader.startAnimating()
    }
    
    func removeLoader() -> Void {
        loader.removeFromSuperview()
    }
}

