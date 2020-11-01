//
//  DetailViewModel.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 31.10.2020.
//

import UIKit

enum CellType {
    case none
    case avatar
    case email
    case firstName
    case lastName
}

struct DetailViewModel {
    
    // MARK: - Properties
    
    
    private(set) var contact: ContactModel
    private let connection = Database.shared
    private let alertService = AlertService()
    
    init(data : ContactModel) {
        contact = data
    }
    
    
    private(set) lazy var detailStructure: Array<CellType> = {
        return [.avatar, .email,.firstName, .lastName]
    }()
    
    // MARK: - Methods
    
    mutating func cellValue(_ indexPath: IndexPath) -> String? {
        let cellType = detailStructure[indexPath.row]
        switch cellType {
        case .avatar:
            return contact.photoUrl
        case .email:
            return contact.email
        case .firstName:
            return contact.firstName
        case .lastName:
            return contact.lastName
        default: // none
            return ""
        }
    }
    
    mutating func cellPlaceHolder(_ indexPath: IndexPath) -> String? {
        let cellType = detailStructure[indexPath.row]
        switch cellType {
        case .avatar:
            return "avatar"
        case .email:
            return "email"
        case .firstName:
            return "firstName"
        case .lastName:
            return "lastName"
        default:
            return "none"
        }
    }
    mutating func didChangeValue(_ cellIndex: IndexPath, value: String?) {
        let cellType = detailStructure[cellIndex.row]
        switch cellType {
        case .avatar:
            contact.photoUrl = value
        case .email:
            contact.email = value
        case .firstName:
            contact.firstName = value
        case .lastName:
            contact.lastName = value
        default:
            break
        }
    }
    
}
extension DetailViewModel {
    mutating func updateContact() {
        let updateContact = ContactModel(firstName: contact.firstName, lastName: contact.lastName, photoURL: contact.photoUrl, email: contact.email, contact.id)
        connection.updateContact(updateContact) {[self] (result) -> (Void) in
            switch result {
            case .success(_) : NotificationCenter.default.post(name: .loadingAfterUpdate, object: nil)
            case .failture(let error) : alertService.alert(error.localizedDescription)
            }
        }
    }
    
    mutating func deleteContact() {
        if let id = contact.id {
            connection.deleteContact(id) { [self] (result) -> (Void) in
                switch result {
                case .success(_) : NotificationCenter.default.post(name: .loadingAfterUpdate, object: nil)
                case .failture(let error) : alertService.alert(error.localizedDescription)
                }
            }
        }
    }
}
