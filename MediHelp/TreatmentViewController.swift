//
//  ViewController.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 12/30/17.
//  Copyright © 2017 Honceiru Mihai. All rights reserved.
//

import UIKit
import CoreData
import DCAnimationKit
class TreatmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
   
    //Outlets
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var leftLineView: UIView!
    @IBOutlet weak var rightLiveView: UIView!
    @IBOutlet weak var noTreatmentLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var addMedLabel: UILabel!
    @IBOutlet weak var useCodeButton: UIButton!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var medicationTable: UITableView!
    
    //Constraints
    @IBOutlet weak var leftLineHeight: NSLayoutConstraint!
    @IBOutlet weak var rightLineHeight: NSLayoutConstraint!
    
    //Properties
    var medications: [Medication]?
  
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.medicationTable.delegate = self
        self.medicationTable.dataSource = self

        
//        
//        medication = Medication(entity: NSEntityDescription.entity(forEntityName: "Medication", in: CoreDataManager.mainViewContext)!, insertInto:CoreDataManager.mainViewContext)
//        medication?.startDate = NSDate(timeIntervalSince1970: 121041)
//        medication?.name = "test"
//        medication?.personName = "persoana"
//        
//        CoreDataManager.saveMainContext()
        
        
    }
    
    
  
    override func viewDidLayoutSubviews() {
        
        circleView.layer.cornerRadius = circleView.bounds.size.height/2
        
     
        circleView.layer.borderColor = UIColor(colorLiteralRed: 35.0/255.0, green: 164.0/255.0, blue: 234.0/255.0, alpha: 1).cgColor
        circleView.layer.borderWidth = 0.8;
        self.leftLineHeight.constant = 0.5;
        self.rightLineHeight.constant = 0.5;
      
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.once(token: "TreatmentAnimations") {
            noTreatmentLabel.isHidden = false
            plusButton.isHidden = false
            addMedLabel.isHidden = false
        noTreatmentLabel.bounce(into: circleView, direction: .top)
        plusButton.bounce(into: circleView, direction: .bottom)
        addMedLabel.bounce(into: circleView, direction: .left)
            useCodeButton.expand(into: self.emptyStateView, finished: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView Delegate & DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row==0){
            var timelineDateCell = tableView.dequeueReusableCell(withIdentifier: "TimelineDateCell") as? TimelineDateCell
            if(timelineDateCell == nil){
                timelineDateCell = TimelineDateCell()
            }
            timelineDateCell!.dateLabel.text = "Luni, 14 Ianuarie"
            timelineDateCell!.topBar.isHidden = true
            return timelineDateCell!
        }
        if(indexPath.row<5&&indexPath.row>0){
            var medicationCell = tableView.dequeueReusableCell(withIdentifier: "MedicationTableViewCell") as? MedicationTableViewCell
            if(medicationCell == nil){
                medicationCell = MedicationTableViewCell()
            }
            switch indexPath.row {
            case 1:
                medicationCell!.configure(isChecked: true, dotColor: UIColor.red, hour: 10, medName: "Nurofen")
            case 2:
                medicationCell!.configure(isChecked: true, dotColor: UIColor.orange, hour: 10, medName: "Paracetamol")
            case 3:
                var currentHourCell = tableView.dequeueReusableCell(withIdentifier: "CurrentHourCell") as? CurrentHourCell
                if(currentHourCell==nil){
                    currentHourCell = CurrentHourCell();
                }
                return currentHourCell!
            case 4:
                medicationCell!.configure(isChecked: true, dotColor: UIColor.green, hour: 10, medName: "Whatever")
            default:
                return medicationCell!
            }
            return medicationCell!
        }
        if(indexPath.row == 5){
            var timelineDateCell = tableView.dequeueReusableCell(withIdentifier: "TimelineDateCell") as? TimelineDateCell
            if(timelineDateCell == nil){
                timelineDateCell = TimelineDateCell()
            }
            timelineDateCell!.dateLabel.text = "Marti, 15 Ianuarie"
            return timelineDateCell!
        }
        if(indexPath.row<8&&indexPath.row>5){
            var medicationCell = tableView.dequeueReusableCell(withIdentifier: "MedicationTableViewCell") as? MedicationTableViewCell
            if(medicationCell == nil){
                medicationCell = MedicationTableViewCell()
            }
            switch indexPath.row {
            case 6:
                medicationCell!.configure(isChecked: true, dotColor: UIColor.red, hour: 10, medName: "Nurofen")
            case 7:
                medicationCell!.configure(isChecked: false, dotColor: UIColor.brown, hour: 10, medName: "Paracetamol")
            default:
                return medicationCell!
            }
            return medicationCell!
        }
        if(indexPath.row == 8){
            var timelineDateCell = tableView.dequeueReusableCell(withIdentifier: "TimelineDateCell") as? TimelineDateCell
            if(timelineDateCell == nil){
                timelineDateCell = TimelineDateCell()
            }
            timelineDateCell!.dateLabel.text = "Miercuri, 16 Ianuarie"
            return timelineDateCell!
        }
        if(indexPath.row<12&&indexPath.row>8){
            var medicationCell = tableView.dequeueReusableCell(withIdentifier: "MedicationTableViewCell") as? MedicationTableViewCell
            if(medicationCell == nil){
                medicationCell = MedicationTableViewCell()
            }
            switch indexPath.row {
            case 9:
                medicationCell!.configure(isChecked: true, dotColor: UIColor.red, hour: 10, medName: "Nurofen")
            case 10:
                medicationCell!.configure(isChecked: true, dotColor: UIColor.blue, hour: 10, medName: "Paracetamol")
            case 11:
                medicationCell!.configure(isChecked: true, dotColor: UIColor.purple, hour: 10, medName: "Paracetamol")
            default:
                return medicationCell!
            }
            return medicationCell!
        }
        var timelineDateCell = tableView.dequeueReusableCell(withIdentifier: "TimelineDateCell") as? TimelineDateCell
        if(timelineDateCell == nil){
            timelineDateCell = TimelineDateCell()
        }
        timelineDateCell?.bottomBar.isHidden = true
        timelineDateCell!.dateLabel.text = "Joi, 17 Ianuarie"
        return timelineDateCell!
    }
    //MARK: Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToAddMedication", sender: sender)
        
    }
    @IBAction func useCodeTapped(_ sender: Any) {
       performSegue(withIdentifier: "goToAddCode", sender: sender)
    }



}

