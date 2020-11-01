//
//  DetailDataSource.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 31.10.2020.
//

import Foundation
import UIKit

class DetailDataSource: NSObject {
    
    weak var controller : DetailController!
    
    lazy var model: DetailViewModel? = controller.model
    
    
    init(_ controller: DetailController) {
        super.init()
        
        self.controller = controller
        self.setupTable()
        self.setupButtons()
        self.reloadContainers()
        self.setupHelpers()
    }
    
    private func setupTable() {
        controller.tableView?.registerCellFromNib(UINib.TextFieldCell)
        controller.tableView?.registerCellFromNib(UINib.AvatarCell)
        controller.tableView?.separatorStyle = .none
        controller.tableView?.delegate = self
        controller.tableView?.dataSource = self
    }
    
    private func setupButtons() {
        let save = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTap))
        let delete = UIBarButtonItem(title: "Del", style: .plain, target: self, action: #selector(delTap))
        self.controller.navigationItem.rightBarButtonItems = [save,delete]
    }
    
    private func setupHelpers(){
        NotificationCenter.default.addObserver(self, selector: #selector(returnMain), name: .loadingAfterUpdate, object: nil)
    }
    
    @objc func saveTap(){
        self.model?.updateContact()
    }
    
    @objc func delTap(){
        self.model?.deleteContact()
    }
    
    
    
    private func cellForRow(_ indexPath: IndexPath) -> BaseCell {
        let cellType = model?.detailStructure[indexPath.row]
        var baseCell: BaseCell = BaseCell()
        switch cellType {
        case .avatar:
            baseCell = self.controller?.tableView?.dequeueReusableCell(withIdentifier:UINib.AvatarCell , for: indexPath) as! BaseCell
            guard let `cell` = baseCell as? AvatarCell else {
                assertionFailure("❌ DetailDataSourse Imposible AvatarCell case.")
                return baseCell
            }
            cell.cellIndex = indexPath
            if let url = self.model?.cellValue(indexPath) {
                cell.setImage(url)
            }
            return cell
        
        case .firstName, .lastName,.email:
            baseCell = self.controller?.tableView?.dequeueReusableCell(withIdentifier:UINib.TextFieldCell , for: indexPath) as! BaseCell
            guard let `cell` = baseCell as? TextFieldCell else {
                assertionFailure("❌ DetailDataSourse Imposible TextFieldCell case.")
                return baseCell
            }
            cell.cellIndex = indexPath
            cell.cellType = cellType ?? .none
            cell.delegate = self
            cell.textField.placeholder = self.model?.cellPlaceHolder(indexPath)
            cell.textField.text = self.model?.cellValue(indexPath)
            return cell
        default:
            return baseCell
        }
    }
    
    @objc func returnMain() {
       _ = controller.navigationController?.popViewController(animated: true)
    }
    
    
    private func reloadContainers() {
        controller.tableView?.reloadData()
    }
    
}

extension DetailDataSource: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.detailStructure.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BaseCell = self.cellForRow(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
// MARK: -
extension DetailDataSource: TextFieldCellProtocol {
    func textFieldDidChangeValue(_ indexPath: IndexPath, value: String?) {
        model?.didChangeValue(indexPath, value: value)
    }
}
