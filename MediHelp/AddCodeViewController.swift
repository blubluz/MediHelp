//
//  AddCodeViewController.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/6/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreData
import SwiftyJSON

class AddCodeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var sendButton: UIButton!
    var ref: DatabaseReference!
    @IBOutlet weak var codeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        codeTextField.delegate = self
        self.addGradientInView(view: view)
        sendButton.layer.borderColor = UIColor.white.cgColor
        sendButton.layer.borderWidth = 0.5
        sendButton.layer.cornerRadius = 20
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Esti sigur?", message: "Adăugarea unui nou tratament va șterge tratamentul deja creat", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Da", style: .destructive, handler: { (action) in
            if let inputText = self.codeTextField.text {
                MediProgressHUD.present(loadingText: "Se sincronizează")
                
                if let fetchedHistoryDays = CoreDataManager.getHistoryDays() {
                    for historyDay in fetchedHistoryDays {
                        CoreDataManager.mainViewContext.delete(historyDay)
                    }
                }
                if let fetchedMeds = CoreDataManager.getMeds() {
                    for med in fetchedMeds {
                        CoreDataManager.mainViewContext.delete(med)
                    }
                }
                CoreDataManager.saveMainContext()
                
                self.ref.child(inputText).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value  = snapshot.value as? Dictionary<String,Any>{
                        MediProgressHUD.dismiss()
                        let json = JSON(value)
                        self.unpackMedications(fromJson: json)
                    }else{
                        MediProgressHUD.dismiss(delay: 1, message: "Nu există acest cod", success: false, completion: nil)

                    }
                }) { (error) in
                    print(error.localizedDescription)
                    MediProgressHUD.dismiss(delay: 1, message: "A intervenit o eroare: \(error.localizedDescription)", success: false, completion: nil)

                }
            }else{
                
            }

        }))
        alertController.addAction(UIAlertAction(title: "Nu", style: .default, handler: { (action) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    func unpackMedications(fromJson : JSON){
       
        if let medicationsArray = fromJson["medications"].array{
            for medicationJson in medicationsArray {
                let medication = Medication(entity: NSEntityDescription.entity(forEntityName: "Medication", in: CoreDataManager.mainViewContext)! , insertInto: CoreDataManager.mainViewContext)
                let dosage = Dosage(entity: NSEntityDescription.entity(forEntityName: "Dosage", in: CoreDataManager.mainViewContext)!, insertInto: CoreDataManager.mainViewContext)
                let frequency = Frequency(entity: NSEntityDescription.entity(forEntityName: "Frequency", in: CoreDataManager.mainViewContext)!, insertInto: CoreDataManager.mainViewContext)
                medication.dosage = dosage
                medication.frequency = frequency
                medication.configureWithJson(json: medicationJson)
                CoreDataManager.generateNewHistoryFor(medication: medication)
            }
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    func addGradientInView(view : UIView?) {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        let gradTopStart = NSNumber(value: 0.0), gradTopEnd = NSNumber(value: 0.5), gradBottomStart = NSNumber(value: 0.55), gradBottomEnd = NSNumber(value: 1.0)
        gradient.locations = [gradTopStart,gradTopEnd,gradBottomStart,gradBottomEnd]
        view?.layoutIfNeeded()
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        let fromColor = UIColor(red: 114.0/255, green: 208.0/255, blue: 226.0/255, alpha: 1)
        let toColor = UIColor(red: 28.0/255, green: 152.0/255, blue: 232.0/255, alpha: 1)
        gradient.colors = [fromColor.cgColor,toColor.cgColor]
        view?.layer.insertSublayer(gradient, at: 0)
    }
    // MARK: - Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        sendTapped(textField)
        return true
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
