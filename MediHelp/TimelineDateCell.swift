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
	let yourViewBorder = CAShapeLayer()
	let yourViewBorder2 = CAShapeLayer()
    override func awakeFromNib() {
        super.awakeFromNib()
		yourViewBorder.strokeColor = UIColor.lightGray.cgColor
		yourViewBorder.lineDashPattern = [2,3]
		yourViewBorder.frame = topBar.bounds
		yourViewBorder.fillColor = nil
		yourViewBorder.path = UIBezierPath(rect: CGRect(x: topBar.bounds.origin.x, y: topBar.bounds.origin.y, width: 0, height: topBar.bounds.size.height)).cgPath
		
		yourViewBorder2.strokeColor = UIColor.lightGray.cgColor
		yourViewBorder2.lineDashPattern = [2,3]
		yourViewBorder2.frame = bottomBar.bounds
		yourViewBorder2.fillColor = nil
		yourViewBorder2.path = UIBezierPath(rect: CGRect(x: bottomBar.bounds.origin.x, y: bottomBar.bounds.origin.y, width: 0, height: bottomBar.bounds.size.height)).cgPath
    }
	public func dashLines() {
	
		topBar.layer.addSublayer(yourViewBorder)
		topBar.backgroundColor = UIColor.clear
	
		bottomBar.layer.addSublayer(yourViewBorder2)
		bottomBar.backgroundColor = UIColor.clear
	}
	override func prepareForReuse() {
		super.prepareForReuse()
		bottomBar.isHidden = false
		topBar.isHidden = false
		bottomBar.backgroundColor = UIColor.black
		topBar.backgroundColor = UIColor.black
		yourViewBorder.removeFromSuperlayer()
		yourViewBorder2.removeFromSuperlayer()
	}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
