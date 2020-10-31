//
//  DetailControllerViewController.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 31.10.2020.
//

import UIKit

class DetailController: BaseController {

    
    @IBOutlet weak var tableView: UITableView!
    lazy var model: DetailViewModel? = nil
    
    lazy var delegate: DetailDataSource = {
        return .init(self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    
    override func prepareViews() {
        super.prepareViews()
        initTableView()
        
//        hideKeyboardOnTap()
    }
    func initTableView() -> Void {
        _ = self.delegate
    }
}
