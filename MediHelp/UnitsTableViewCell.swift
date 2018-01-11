//
//  UnitsTableViewCell.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/6/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import UIKit

class UnitsTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellSeparator: UIView!
    @IBOutlet weak var cellSeparatorHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellSeparatorHeight.constant = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
