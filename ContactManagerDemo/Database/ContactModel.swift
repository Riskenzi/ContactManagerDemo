//
//  ContactModel.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 30.10.2020.
//

import Foundation
struct ContactModel : Decodable {
    let id: Int?
    let firstName : String?
    let lastName : String?
    let photoUrl : String?
    let email : String?
    
    init(firstName : String? , lastName : String?, photoURL : String?, email : String?,_ id : Int? = 0) {
        self.firstName  = firstName
        self.lastName = lastName
        self.photoUrl = photoURL
        self.email = email
        self.id = id
    }
}
