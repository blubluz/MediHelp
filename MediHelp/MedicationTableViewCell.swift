//
//  MedicationTableViewCell.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/12/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import UIKit
@objc public enum MedicationTakenState : Int16 {
	case taken,notTaken,unknown
}
class MedicationTableViewCell: UITableViewCell {
	
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var medicationNameLabel: UILabel!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var takePillButton: UIButton!
    @IBOutlet weak var rescheduleButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dosageLabel: UILabel!
	@IBOutlet weak var lineView: UIView!
	let yourViewBorder = CAShapeLayer()
	override func awakeFromNib() {
        super.awakeFromNib()
		yourViewBorder.strokeColor = UIColor.lightGray.cgColor
		yourViewBorder.lineDashPattern = [2,3]
		yourViewBorder.frame = lineView.bounds
		yourViewBorder.fillColor = nil
		yourViewBorder.path = UIBezierPath(rect: CGRect(x:lineView.bounds.origin.x, y: lineView.bounds.origin.y, width: 0, height: lineView.bounds.size.height)).cgPath
    }
    public func configure(isTaken : MedicationTakenState, dotColor: UIColor?, hour : Int, medName: String?){
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
			lineView.layer.addSublayer(yourViewBorder)
			lineView.backgroundColor = UIColor.clear
			self.containerView.backgroundColor = UIColor.white
		}
        
        self.medicationNameLabel.text = medName
    }
    public func configure(historyEntity : HistoryEntity){
        self.configure(isTaken: historyEntity.taken, dotColor: historyEntity.medication?.tagColor, hour: Int(historyEntity.hour), medName: historyEntity.medication?.name)
        self.dosageLabel.text = "\(String(format: "%.0f", historyEntity.medication?.dosage?.amount ?? 0)) \(historyEntity.medication?.dosage?.units ?? "")"
        self.dosageLabel.textColor = historyEntity.medication?.tagColor

    }
	override func prepareForReuse() {
		super.prepareForReuse()
		lineView.backgroundColor = UIColor.black
		self.containerView.backgroundColor = UIColor.black
		yourViewBorder.removeFromSuperlayer()
	}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
