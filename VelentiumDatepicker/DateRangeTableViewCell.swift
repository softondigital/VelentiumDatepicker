//
//  DateRangeTableViewCell.swift
//  VelentiumDatepicker
//
//  Created by Hugo Aguero on 4/29/17.
//  Copyright © 2017 Velentium. All rights reserved.
//

import UIKit

class DateRangeTableViewCell: UITableViewCell {
    
    @IBOutlet var dateRangeHeaderLabel: UILabel!
    @IBOutlet var dateRangeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
