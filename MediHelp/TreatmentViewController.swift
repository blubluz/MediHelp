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
    var historyDays : [HistoryDay]?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.medicationTable.delegate = self
        self.medicationTable.dataSource = self
       
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
        
        
        let historyDaysFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryDay")
        let sortDescriptor = NSSortDescriptor(key: "day", ascending: true)
        historyDaysFetch.sortDescriptors = [sortDescriptor]
        
        do{
            let fetchedHistoryDays = try CoreDataManager.mainViewContext.fetch(historyDaysFetch) as! [HistoryDay]
            if fetchedHistoryDays.count > 0 {
                for index in 0 ... fetchedHistoryDays.count-1 {
                    print(fetchedHistoryDays[index])
                }
                self.medicationTable.isHidden = false
                self.historyDays = fetchedHistoryDays
                self.medicationTable.reloadData()
            } else {
                self.medicationTable.isHidden = true
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
        }catch {
            fatalError("Failed to fetch HistoryDays: \(error)")

        }
        
        
      
    }
    override func viewWillAppear(_ animated: Bool) {
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Helper methods
    func generateHistoryTable(){
        
    }
    //MARK: TableView Delegate & DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 13
        if let count = self.historyDays?.count {
            return count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row==0){
            var timelineDateCell = tableView.dequeueReusableCell(withIdentifier: "TimelineDateCell") as? TimelineDateCell
            if(timelineDateCell == nil){
                timelineDateCell = TimelineDateCell()
            }
            timelineDateCell!.dateLabel.text = "Astăzi"
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
                medicationCell!.configure(isTaken: .taken, dotColor: UIColor.red, hour: 3600*8, medName: "Nurofen")
            case 2:
                medicationCell!.configure(isTaken: .notTaken, dotColor: UIColor.brown, hour: 3600*12, medName: "Paracetamol")
            case 3:
                var currentHourCell = tableView.dequeueReusableCell(withIdentifier: "CurrentHourCell") as? CurrentHourCell
                if(currentHourCell==nil){
                    currentHourCell = CurrentHourCell();
                }
                return currentHourCell!
            case 4:
                medicationCell!.configure(isTaken: .unknown, dotColor: UIColor.blue, hour: 3600*20, medName: "Lyrica")
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
            timelineDateCell!.dateLabel.text = "Marți, 15 Ianuarie"
			timelineDateCell!.dashLines()
            return timelineDateCell!
        }
        if(indexPath.row<8&&indexPath.row>5){
            var medicationCell = tableView.dequeueReusableCell(withIdentifier: "MedicationTableViewCell") as? MedicationTableViewCell
            if(medicationCell == nil){
                medicationCell = MedicationTableViewCell()
            }
            switch indexPath.row {
            case 6:
                medicationCell!.configure(isTaken: .unknown, dotColor: UIColor.red, hour: 3600*8, medName: "Nurofen")
            case 7:
                medicationCell!.configure(isTaken: .unknown, dotColor: UIColor.brown, hour: 3600*16, medName: "Paracetamol")
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
			timelineDateCell!.dashLines()
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
                medicationCell!.configure(isTaken: .unknown, dotColor: UIColor.red, hour: 3600*8, medName: "Nurofen")
            case 10:
                medicationCell!.configure(isTaken: .unknown, dotColor: UIColor.brown, hour: 3600*12, medName: "Paracetamol")
            case 11:
                medicationCell!.configure(isTaken: .unknown, dotColor: UIColor.brown, hour: 3600*18, medName: "Paracetamol")
            default:
                return medicationCell!
            }
            return medicationCell!
        }
        var timelineDateCell = tableView.dequeueReusableCell(withIdentifier: "TimelineDateCell") as? TimelineDateCell
        if(timelineDateCell == nil){
            timelineDateCell = TimelineDateCell()
        }
		timelineDateCell!.dashLines()
        timelineDateCell!.bottomBar.isHidden = true
        timelineDateCell!.dateLabel.text = "Tratament terminat"
        return timelineDateCell!
    }
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 36
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		alertController.addAction(UIAlertAction(title: "Ia medicament", style: .default, handler: nil))
		alertController.addAction(UIAlertAction(title: "Reprogramează", style: .default, handler: nil))
		alertController.addAction(UIAlertAction(title: "Anulează", style: .cancel, handler: nil))
		self.present(alertController, animated: true, completion: nil)
	}
    //MARK: Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToAddMedication", sender: sender)
        
    }
    @IBAction func useCodeTapped(_ sender: Any) {
       performSegue(withIdentifier: "goToAddCode", sender: sender)
    }



}

