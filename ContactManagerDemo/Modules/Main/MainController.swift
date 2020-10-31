//
//  MainController.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 30.10.2020.
//

import UIKit

class MainController: BaseController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var delegate: MainDataSource = {
        return .init(self)
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.tableView.reloadData()
    }
    
    override func setupAppearances() {
        super.setupAppearances()
        self.title = "Contact List"
        tableView?.backgroundColor = .clear
    }
    
    override func setupObservers() {
        super.setupObservers()
    }
    
    func initTableView() -> Void {
        _ = self.delegate
    }
}
