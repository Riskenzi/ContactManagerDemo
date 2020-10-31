//
//  ContactModel.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 30.10.2020.
//

import Foundation
struct ContactModel : Decodable {
    var id: Int?
    var firstName : String?
    var lastName : String?
    var photoUrl : String?
    var email : String?
    
    init(firstName : String? , lastName : String?, photoURL : String?, email : String?,_ id : Int? = 0) {
        self.firstName  = firstName
        self.lastName = lastName
        self.photoUrl = photoURL
        self.email = email
        self.id = id
    }
}
