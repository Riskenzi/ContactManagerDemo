//
//  ContactViewCell.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 31.10.2020.
//

import UIKit

class ContactViewCell: UITableViewCell {
    
    static let kCell = UINib.idenXibTopicCell

    @IBOutlet weak var imageCell: LoadingImageView!
    
    @IBOutlet weak var firstNameLb: UILabel!
    
    @IBOutlet weak var lastNameLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func show( _ data: ContactModel) {
        
        if let urlPath = data.photoUrl {
            if GlobalService.verifyUrl(urlString: urlPath) {
                imageCell.loadImage(from: urlPath)
            }
        }
        firstNameLb.text = data.firstName
        firstNameLb.sizeToFit()
        
        lastNameLb.text = data.lastName
        lastNameLb.sizeToFit()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
