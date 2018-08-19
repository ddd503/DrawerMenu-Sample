//
//  JobOffer.swift
//  DrawerMenu-Sample
//
//  Created by kawaharadai on 2018/08/15.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Kingfisher
import UIKit

class JobOffer {
    var companyName = ""
    var companyNumber: Int32 = 0
    var location = ""
    var salary = ""
    var summary = ""
    var companyImageUrl = ""
    
    init(result: FMResultSet) {
        self.companyNumber = result.int(forColumn: "company_no")
        self.location = result.string(forColumn: "job_location") ?? ""
        self.salary = result.string(forColumn: "job_salary") ?? ""
        self.summary = result.string(forColumn: "job_detail_info") ?? ""
        self.companyImageUrl = result.string(forColumn: "job_image_url") ?? ""
    }
}
