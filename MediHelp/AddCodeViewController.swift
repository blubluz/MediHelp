//
//  AddCodeViewController.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/6/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import UIKit

class AddCodeViewController: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientInView(view: view)
        sendButton.layer.borderColor = UIColor.white.cgColor
        sendButton.layer.borderWidth = 0.5
        sendButton.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGradientInView(view : UIView?) {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        let gradTopStart = NSNumber(value: 0.0), gradTopEnd = NSNumber(value: 0.5), gradBottomStart = NSNumber(value: 0.55), gradBottomEnd = NSNumber(value: 1.0)
        gradient.locations = [gradTopStart,gradTopEnd,gradBottomStart,gradBottomEnd]
        view?.layoutIfNeeded()
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        let fromColor = UIColor(colorLiteralRed: 114.0/255, green: 208.0/255, blue: 226.0/255, alpha: 1)
        let toColor = UIColor(colorLiteralRed: 28.0/255, green: 152.0/255, blue: 232.0/255, alpha: 1)
        gradient.colors = [fromColor.cgColor,toColor.cgColor]
        view?.layer.insertSublayer(gradient, at: 0)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
