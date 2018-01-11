//
//  MedicationTableViewCell.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/12/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import UIKit

class MedicationTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var medicationNameLabel: UILabel!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var takePillButton: UIButton!
    @IBOutlet weak var rescheduleButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public func configure(isChecked : Bool, dotColor: UIColor, hour : Int, medName: String){
        self.dotView.backgroundColor = dotColor;
        self.timeLabel.textColor = dotColor;
        self.medicationNameLabel.textColor = dotColor;
        if(isChecked == true){
            self.containerView.backgroundColor = UIColor(red: 60/255.0, green: 241/255.0, blue: 96/255.0, alpha: 0.19)
        }else{
            self.containerView.backgroundColor = UIColor(red: 211/255.0, green: 41/255.0, blue: 30/255.0, alpha: 0.19)

        }
        
        self.medicationNameLabel.text = medName
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
