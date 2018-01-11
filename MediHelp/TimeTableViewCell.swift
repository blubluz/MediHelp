//
//  TimeTableViewCell.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/7/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var cellSeparatorHeigh: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellSeparatorHeigh.constant = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
