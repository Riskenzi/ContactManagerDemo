//
//  AvatarCell.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 31.10.2020.
//

import UIKit

class AvatarCell: BaseCell {

    @IBOutlet weak var imageCell: LoadingImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageCell.layer.masksToBounds = true
        imageCell.layer.cornerRadius = imageCell.bounds.size.height / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setImage(_ urlPath : String) {
        if GlobalService.verifyUrl(urlString: urlPath) {
            imageCell.loadImage(from: urlPath)
        }
    }
    
}
