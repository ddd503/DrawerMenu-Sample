//
//  LeftNavigationDrawerViewController.swift
//  DrawerMenu-Sample
//
//  Created by kawaharadai on 2018/08/15.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit
protocol DrawerViewControllerDelegate: class {
    func reloadJobOfferList(sort: SortType)
}

final class LeftNavigationDrawerViewController: UIViewController {
    
    @IBOutlet weak var menuTableView: UITableView!
    private let datasource = LeftNavigationDrawerDataSource()
    weak var delegate: DrawerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup() {
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self.datasource
        self.menuTableView.tableFooterView = UIView()
    }
    
}

extension LeftNavigationDrawerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.reloadJobOfferList(sort: self.datasource.sortLabels[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
