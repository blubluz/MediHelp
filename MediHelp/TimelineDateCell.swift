//
//  TimelineDateCell.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/12/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import UIKit

class TimelineDateCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var midBar: UIView!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var topBar: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	public func dashLines() {
		var yourViewBorder = CAShapeLayer()
		yourViewBorder.strokeColor = UIColor.lightGray.cgColor
		yourViewBorder.lineDashPattern = [2,3]
		yourViewBorder.frame = topBar.bounds
		yourViewBorder.fillColor = nil
		yourViewBorder.path = UIBezierPath(rect: CGRect(x: topBar.bounds.origin.x, y: topBar.bounds.origin.y, width: 0, height: topBar.bounds.size.height)).cgPath
		topBar.layer.addSublayer(yourViewBorder)
		topBar.backgroundColor = UIColor.white
		
		var yourViewBorder2 = CAShapeLayer()
		yourViewBorder2.strokeColor = UIColor.lightGray.cgColor
		yourViewBorder2.lineDashPattern = [2,3]
		yourViewBorder2.frame = bottomBar.bounds
		yourViewBorder2.fillColor = nil
		yourViewBorder2.path = UIBezierPath(rect: CGRect(x: bottomBar.bounds.origin.x, y: bottomBar.bounds.origin.y, width: 0, height: bottomBar.bounds.size.height)).cgPath
		bottomBar.layer.addSublayer(yourViewBorder2)
		bottomBar.backgroundColor = UIColor.white
	}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
