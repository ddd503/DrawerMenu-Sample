//
//  LeftNavigationDrawerDataSource.swift
//  DrawerMenu-Sample
//
//  Created by kawaharadai on 2018/08/18.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit

final class LeftNavigationDrawerDataSource: NSObject {
    let sortLabels = [SortType.postingStartDate, SortType.postingEndDate]
    private let cellIdentifier = "Cell"
}

extension LeftNavigationDrawerDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "並び替え"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = sortLabels[indexPath.row].title
        return cell
    }
    
}
