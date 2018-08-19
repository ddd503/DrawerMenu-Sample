//
//  JobOfferListDatasource.swift
//  DrawerMenu-Sample
//
//  Created by kawaharadai on 2018/08/15.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

final class JobOfferListDatasource: NSObject {
    var jobOfferList: [JobOffer] = []
}

extension JobOfferListDatasource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobOfferList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JobOfferListCell.identifier,
                                                       for: indexPath) as? JobOfferListCell else {
                                                        fatalError("cell is nil")
        }
        cell.jobOffer = self.jobOfferList[indexPath.row]
        return cell
    }
    
}
