//
//  SortType.swift
//  DrawerMenu-Sample
//
//  Created by kawaharadai on 2018/08/18.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

enum SortType: String {
    case postingStartDate
    case postingEndDate
    
    var title: String {
        switch self {
        case .postingStartDate:
            return "新着順"
        case .postingEndDate:
            return "掲載終了日が早い順"
        }
    }
    
    var key: String {
        switch self {
        case .postingStartDate:
            return "posting_start_date"
        case .postingEndDate:
            return "posting_end_date"
        }
    }
}
