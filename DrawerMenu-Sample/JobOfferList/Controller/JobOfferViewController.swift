//
//  JobOfferViewController.swift
//  DrawerMenu-Sample
//
//  Created by kawaharadai on 2018/08/15.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

final class JobOfferViewController: UIViewController {
    
    @IBOutlet weak var jobOfferListTableView: UITableView!
    private let datasource = JobOfferListDatasource()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getDatasource()
    }
    
    // MARK: - Private
    private func setup() {
        self.jobOfferListTableView.dataSource = self.datasource
        self.jobOfferListTableView.register(UINib(nibName: JobOfferListCell.identifier, bundle: nil),
                                            forCellReuseIdentifier: JobOfferListCell.identifier)
    }
    
    private func getDatasource() {
        self.datasource.jobOfferList =
            JobOfferListDao.shered.selectAll(tableName: "job_master",
                                             sort: SortType.postingStartDate.key,
                                             ascOrDesc: "ASC")
        
    }
    
    func reload(sortType: SortType) {
        self.datasource.jobOfferList =
            JobOfferListDao.shered.selectAll(tableName: "job_master",
                                             sort: sortType.key,
                                             ascOrDesc: "ASC")
        self.jobOfferListTableView.reloadData()
        // スクロールを上まで戻す
        self.jobOfferListTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
}
