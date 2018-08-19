//
//  JobOfferListCell.swift
//  DrawerMenu-Sample
//
//  Created by kawaharadai on 2018/08/15.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import Kingfisher
import UIKit

final class JobOfferListCell: UITableViewCell {
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var companyImageView: UIImageView!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    var jobOffer: JobOffer? {
        didSet {
            self.companyNameLabel.text = jobOffer?.companyName
            self.locationLabel.text = jobOffer?.location
            self.salaryLabel.text = jobOffer?.salary
            self.summaryTextView.text = jobOffer?.summary
            guard
                let imageUrlString = jobOffer?.companyImageUrl,
                let imageUrl = URL(string: imageUrlString) else { return }
            self.companyImageView.kf.setImage(with: imageUrl)
        }
    }
    
}
