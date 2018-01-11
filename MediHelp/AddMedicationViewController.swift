//
//  AddMedicationViewController.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/6/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import UIKit

class AddMedicationViewController: UIViewController,UITextFieldDelegate,ChooseUnitDelegate {

    @IBOutlet weak var nameIconImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pillIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pillIconHeight: NSLayoutConstraint!
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var unitView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorTag: UILabel!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBOutlet weak var containerView: UIView!
    var selectedColourButton : UIButton?
    var didCommitAnimation = false
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        quantityView.isHidden = true
        unitView.isHidden = true
        colorView.isHidden = true
        colorTag.isHidden = true
        self.nextButton.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func didTapUnitsButton(_ sender: Any) {
        self.performSegue(withIdentifier: "goToChooseUnit", sender: sender)
    }
    @IBAction func nextTapped(_ sender: Any) {
        if(checkFields()==true){
            performSegue(withIdentifier: "goToFrequency", sender: sender)
        }
    }
    @IBAction func didTapColor(_ sender: Any) {
        if(selectedColourButton != nil){
            UIView.animate(withDuration: 0.2, animations: { 
                self.selectedColourButton?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        if let senderButton = sender as? UIButton {
            selectedColourButton = senderButton
            switch senderButton.tag {
            case 0:
                break;
            default:
                break;
            }
            
            UIView.animate(withDuration: 0.08, animations: {
                senderButton.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            }, completion: { (success) in
                UIView.animate(withDuration: 0.12, animations: {
                    senderButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }, completion: {(success) in
                    UIView.animate(withDuration: 0.17, animations: {
                        senderButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                        
                    })
            })
        })
        }
    }
    func checkFields() -> Bool {
        if(nameTextField.text == ""){
            nameTextField.attributedPlaceholder = NSAttributedString(string: "Nume",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.transparentRed])
            nameTextField.shake(nil)
          
            return false
        }
        if(quantityTextField.text == ""){
            quantityTextField.attributedPlaceholder = NSAttributedString(string: "Cantitate",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.transparentRed])
            quantityTextField.shake(nil)
            return false
        }
        if(unitTextField.text == ""){
            unitTextField.attributedPlaceholder = NSAttributedString(string: "Unitate",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.transparentRed])
            unitTextField.shake(nil)
            return false
        }
        return true
    }
    //MARK: - Text field delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextField {
            if didCommitAnimation == false {
                didCommitAnimation = true
                UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
                    self.pillIconHeight.constant = 35;
                    
                }, completion: nil)
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == nameTextField){
            if nameTextField.text != "" {
                if(quantityView.isHidden == true){
                    nextButton.isEnabled = true
                    quantityView.isHidden = false
                    unitView.isHidden = false
                    colorView.isHidden = false
                    colorTag.isHidden = false
                    colorTag.alpha = 0;
                    colorView.alpha = 0
                    quantityView.alpha = 0
                    unitView.alpha = 0
                    UIView.animate(withDuration: 0.4, animations: {
                        [unowned self] in
                        self.colorTag.alpha = 1
                        self.colorView.alpha = 1
                        self.quantityView.alpha = 1
                        self.unitView.alpha = 1
                    })
                    
                }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    //MARK: - ChooseUnitDelegate
    func didChooseUnit(unitName: String) {
        unitTextField.text = unitName
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChooseUnit" {
            let destination = segue.destination as! ChooseUnitViewController
            destination.delegate = self
        }
    }
 

}
