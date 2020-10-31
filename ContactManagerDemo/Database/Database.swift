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
    
    
    static let shared = Database()
    private var database: Connection!
    
    private let contactTable = Table("contacts")
    private let id = Expression<Int>("id")
    private let firstName  = Expression<String>("firstName")
    private let lastName  = Expression<String>("lastName")
    private let photoUrl  = Expression<String>("photoUrl")
    private let email  = Expression<String>("email")
    
  
    
    private init(){
        do {
            let documentDirectory =  try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("contacts").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            print(Log.initDatabase.rawValue)
            createTableContants()
        }catch{
            print(error.localizedDescription,"⚠️")
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
            print(error.localizedDescription,"⚠️")
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
        //print(Log.showAllItems.rawValue,contactsData)
        return contactsData
    }
    
    public func getContactByID(_ idItem : Int) -> ContactModel? {
        var contactData : ContactModel?
        do {
            
            let foundItem = contactTable.filter(id == idItem)
            let results = try self.database.prepare(foundItem)
            for result in results {
                contactData = ContactModel(firstName: result[self.firstName], lastName: result[self.lastName], photoURL: result[self.photoUrl], email: result[self.email], result[self.id])
            }
        } catch  {
           print(error.localizedDescription)
        }
        //print(Log.contactByID,contactData ?? nil)
        return contactData
    }
    
    public func deleteContact(_ idItem : Int) -> Void {
        let contact = self.contactTable.filter(self.id == idItem)
        let delete = contact.delete()
        do {
            try self.database.run(delete)
            print(Log.delete.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func clearContacts() -> Void {
        let contacts = self.contactTable.delete()
        do {
            try self.database.run(contacts)
            print(Log.deleteAll.rawValue)
            createTableContants()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}



