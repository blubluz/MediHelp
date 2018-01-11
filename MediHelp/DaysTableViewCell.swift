//
//  DaysTableViewCell.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/7/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import UIKit

class DaysTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTextField: UITextField!
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var cellSeparatorHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellSeparatorHeight.constant = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkMark.isHidden = !selected
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkMark.isHidden = true
    }

}
