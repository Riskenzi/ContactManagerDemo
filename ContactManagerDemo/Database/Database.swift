//
//  Database.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 30.10.2020.
//

import Foundation
import SQLite

class Database {
    
   private enum Log : String {
        case initDatabase = "Log : Database Created 🚀"
        case createTable = "Log : Table Created 🚀"
        case addedContact = "Log : Contact Created 🚀"
        case delete = "Log : Contact Deleted Done 🚀"
        case deleteAll = "Log : Contacts Deleted Done 🚀"
        case contactByID = "Log : Contact by id -> ⚡️"
        case showAllItems = "Log : All Items -> ⚡️"
    }
    
    enum Result<T,E:Error> {
        case success(T)
        case failture(E)
    }
    
    
    static let shared = Database()
    private var database: Connection!
    private let alertService = AlertService()
    
    private let contactTable = Table("contacts")
    private let id = Expression<Int>("id")
    private let firstName  = Expression<String>("firstName")
    private let lastName  = Expression<String>("lastName")
    private let photoUrl  = Expression<String>("photoUrl")
    private let email  = Expression<String>("email")
    
    typealias deleteCompletion = ((_ isSuccess: Result<Bool,DatabaseError>)->(Void))
    typealias updateCompletion = ((_ isSuccess: Result<Bool,DatabaseError>)->(Void))
    typealias clearCompletion = ((_ isSuccess: Result<Bool,DatabaseError>)->(Void))
    
    private init(){
        do {
            let documentDirectory =  try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("contacts").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            print(Log.initDatabase.rawValue)
            createTableContants()
        }catch{
            print(DatabaseError.invalidLoadDatabase.errorDescription!)
            
        }
       
    }
    
    
    private func createTableContants() -> Void {
        let createTable = self.contactTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.firstName)
            table.column(self.lastName)
            table.column(self.photoUrl)
            table.column(self.email,unique: true)
        }
        do {
            try self.database.run(createTable)
            print(Log.createTable.rawValue)
        } catch  {
            print(DatabaseError.invalidTable.errorDescription!)
        }
    }
    
    public func addContatToDatabase(data : ContactModel) -> Void {
        
        guard let firstName = data.firstName , let lastName = data.lastName, let photoUrl = data.photoUrl, let email = data.email else { return }
        
        let insert = self.contactTable.insert(self.firstName <- firstName, self.lastName <- lastName, self.photoUrl <- photoUrl, self.email <- email)
        
        do {
            try self.database.run(insert)
            print(Log.addedContact.rawValue,"\(email)")
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    
    public func getAllContacts() -> [ContactModel]? {
        var contactsData = [ContactModel]()
        do {
            let contacts = try self.database.prepare(self.contactTable)
            for contact in contacts {
              

                let contactItem : ContactModel = ContactModel(firstName: contact[self.firstName], lastName: contact[self.lastName], photoURL: contact[self.photoUrl], email: contact[self.email], contact[self.id])
                
                contactsData.append(contactItem)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        return contactsData
    }
    
    public func updateContact(_ data: ContactModel?,completion: @escaping updateCompletion) {
        guard let id = data?.id, let firstName = data?.firstName, let lastName = data?.lastName, let email = data?.email else { return }
        let contact = self.contactTable.filter(self.id == id)
        let updateContact = contact.update(self.email <- email, self.lastName <- lastName, self.firstName <- firstName)
        do {
            try self.database.run(updateContact)
            completion(.success(true))
        } catch {
            completion(.failture(.invalidUpdate))
        }
        
    }
    
    public func deleteContact(_ idItem : Int,completion: @escaping deleteCompletion) {
        let contact = self.contactTable.filter(self.id == idItem)
        let delete = contact.delete()
        do {
            try self.database.run(delete)
            completion(.success(true))
        } catch {
            completion(.failture(.invalidDeleting))
        }
    }
    
    public func clearContacts(completion: @escaping clearCompletion) -> Void {
        let contacts = self.contactTable.delete()
        do {
            try self.database.run(contacts)
            createTableContants()
            completion(.success(true))
        } catch {
            completion(.failture(.invalidClearing))
        }
    }
    
}



enum DatabaseError : String,Error {
    case invalidLoadDatabase = "⚠️Database not created ⚠️"
    case invalidTable = "⚠️Table not created ⚠️"
    case invalidCreateItem = "⚠️Item adding failed ⚠️"
    case invalidGetAllContent = "⚠️Error loading all items from database⚠️"
    case invalidUpdate = "⚠️Update item failed⚠️"
    case invalidDeleting = "⚠️Deleting failed⚠️"
    case invalidClearing = "⚠️Clearing failed⚠️"
}


extension DatabaseError : LocalizedError {
    var errorDescription: String? {return NSLocalizedString(rawValue, comment: "")}
}
