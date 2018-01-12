//
//  MedicationTableViewCell.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/12/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import UIKit
enum MedicationTakenState {
	case taken,notTaken,unknown
}
class MedicationTableViewCell: UITableViewCell {
	
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var medicationNameLabel: UILabel!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var takePillButton: UIButton!
    @IBOutlet weak var rescheduleButton: UIButton!
    @IBOutlet weak var containerView: UIView!
	@IBOutlet weak var lineView: UIView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public func configure(isTaken : MedicationTakenState, dotColor: UIColor, hour : Int, medName: String){
        self.dotView.backgroundColor = dotColor;
        self.timeLabel.textColor = dotColor;
        self.medicationNameLabel.textColor = dotColor;
		let hours = String(hour/3600 % 24)
		let minutes = String(format: "%02d", (hour - ((hour/3600) * 3600) ) / 60)
		self.timeLabel.text = "\(hours):\(minutes)"
		switch isTaken {
		case .taken:
			self.containerView.backgroundColor = UIColor(red: 60/255.0, green: 241/255.0, blue: 96/255.0, alpha: 0.19)
		case .notTaken:
			self.containerView.backgroundColor = UIColor(red: 211/255.0, green: 41/255.0, blue: 30/255.0, alpha: 0.19)
		case .unknown:
			let yourViewBorder = CAShapeLayer()
			yourViewBorder.strokeColor = UIColor.lightGray.cgColor
			yourViewBorder.lineDashPattern = [2,3]
			yourViewBorder.frame = lineView.bounds
			yourViewBorder.fillColor = nil
			yourViewBorder.path = UIBezierPath(rect: CGRect(x: lineView.bounds.origin.x, y: lineView.bounds.origin.y, width: 0, height: lineView.bounds.size.height)).cgPath
			lineView.layer.addSublayer(yourViewBorder)
			lineView.backgroundColor = UIColor.white
			self.containerView.backgroundColor = UIColor.white
		}
        
        self.medicationNameLabel.text = medName
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
