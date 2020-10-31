//
//  MainDataSource.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 31.10.2020.
//

import Foundation
import UIKit

class MainDataSource: NSObject {
    
    weak var controller : MainController!
    
    private let connection = Database.shared
    private let alertService = AlertService()
        
    private var refreshControl = UIRefreshControl()
    
    private var contactsDB : [ContactModel] {
        get {
            return connection.getAllContacts() ?? []
        }
    }
    
    // MARK: - Life cycle
    
    init(_ controller: MainController) {
        super.init()
        
        self.controller = controller
        self.setupTable()
        self.setupRefresh()
        self.prepareTableContentToDisplay()
    }
    
    private func setupTable() {
        
        controller.tableView?.registerCellFromNib(UINib.idenXibTopicCell)
        controller.tableView?.separatorStyle = .none
        controller.tableView?.delegate = self
        controller.tableView?.dataSource = self
        controller.tableView?.rowHeight = UITableView.automaticDimension
        controller.tableView?.estimatedRowHeight = 600

    }
    
    private func prepareTableContentToDisplay() {
        self.connection.clearContacts(completion: { (resultData) -> (Void) in
            switch resultData {
            case .success(_):
                self.featchContacts()
            case .failture(let error):
                self.alertService.alert(error.localizedDescription)
            }
        })
    }
    
    private func featchContacts(){
        Networking.shared.getContactsHandler { [weak self] result in
            switch result {
            case .success(let contacts):
                contacts.results?.forEach({ (contact) in
                    guard let fName = contact.name?.first , let lName = contact.name?.last, let photoUrl = contact.picture?.medium, let email = contact.email else {
                        return
                    }
                    let newContact = ContactModel(firstName: fName, lastName: lName, photoURL: photoUrl, email: email)
                    self?.connection.addContatToDatabase(data: newContact)
                    
                })
                self?.reloadContainers()
            case .failture(let error):
                self?.alertService.alert(error.localizedDescription)
            }
        }
    }
    
    private func setupRefresh() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        controller.tableView?.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
      prepareTableContentToDisplay()
      refreshControl.endRefreshing()
    }
    
    private func reloadContainers() {
        DispatchQueue.main.async { [weak self] in
            self?.controller.tableView?.reloadData()
        }
    }
    
}
extension MainDataSource : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  contactsDB.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row > contactsDB.count - 1) {
            return UITableViewCell()
        }else {
            let  cell = self.controller?.tableView?.dequeueReusableCell(withIdentifier:UINib.idenXibTopicCell , for: indexPath) as! ContactViewCell
            cell.show(contactsDB[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = contactsDB[indexPath.row]
        guard let navigation = self.controller.navigationController else { return }
        Navigation.navigateFullScreen(in: navigation,data)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "DEL") { (action, view, bool) in
            guard let data = self.contactsDB[indexPath.row].id else {
                return
            }
            self.connection.deleteContact(data) { status -> (Void) in
                switch status {
                case .success(_) :
                    self.reloadContainers()
                case .failture(let error) : self.alertService.alert(error.localizedDescription)
                }
            }
            
        }
        deleteAction.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}
