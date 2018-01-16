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
    
	@IBOutlet weak var deleteButton: UIBarButtonItem!
	//Constraints
    @IBOutlet weak var leftLineHeight: NSLayoutConstraint!
    @IBOutlet weak var rightLineHeight: NSLayoutConstraint!
    
    //Properties
    var historyDays : [HistoryDay]?
	var historyDaysAndEntities : [Any] = []
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
			NSLog("Documents Directory: %@", directoryUrl as NSURL)
		}
        self.medicationTable.delegate = self
        self.medicationTable.dataSource = self
       
    }
    
    
  
    override func viewDidLayoutSubviews() {
        
        circleView.layer.cornerRadius = circleView.bounds.size.height/2
        
     
        circleView.layer.borderColor = UIColor(red: 35.0/255.0, green: 164.0/255.0, blue: 234.0/255.0, alpha: 1).cgColor
        circleView.layer.borderWidth = 0.8;
        self.leftLineHeight.constant = 0.5;
        self.rightLineHeight.constant = 0.5;
      
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		refetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	//MARK: - Actions
	
	@IBAction func trashButtonTapped(_ sender: Any) {
		let alertController = UIAlertController(title: "Sterge tratamentul", message: "Ești sigur că dorești să ștergi acest tratament?", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Da", style: .destructive, handler: { (action) in
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
			self.refetchData()
		}))
		alertController.addAction(UIAlertAction(title: "Nu", style: .cancel, handler: { (action) in
			
		}))
		present(alertController, animated: true, completion: nil)
	}
	//MARK: - Helper methods
	func refetchData() {
		if let fetchedHistoryDays = CoreDataManager.getHistoryDays() {
			
			CoreDataManager.resyncHistoryEntities()
			for index in 0 ... fetchedHistoryDays.count-1 {
				print(fetchedHistoryDays[index].historyEntities?.count ?? "No history entities found for this day")
			}
			self.deleteButton.isEnabled = false
			self.medicationTable.isHidden = false
			self.historyDays = fetchedHistoryDays
			
			//Create an array of history days and entities combined
			//Helps us for easily passing data to the table
			self.historyDaysAndEntities = []
			for historyDay in historyDays! {
				self.historyDaysAndEntities.append(historyDay)
				self.historyDaysAndEntities.append(contentsOf: (historyDay.historyEntities?.sortedArray(using: [NSSortDescriptor(key: "hour", ascending: true)]))!)
				//				for historyEntity in  {
				//					self.historyDaysAndEntities.append(historyEntity)
				//				}
			}
			self.medicationTable.reloadData()
		}else{
			self.deleteButton.isEnabled = true
			self.historyDays = nil
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
	}
    //MARK: TableView Delegate & DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return historyDaysAndEntities.count == 0 ? 0 : historyDaysAndEntities.count+1
	}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if(indexPath.row != historyDaysAndEntities.count){
		if let historyObject = self.historyDaysAndEntities[indexPath.row] as? HistoryDay {
			var timelineDateCell = tableView.dequeueReusableCell(withIdentifier: "TimelineDateCell") as? TimelineDateCell
			if(timelineDateCell == nil){
				timelineDateCell = TimelineDateCell()
			}
			if indexPath.row == 0 {
				timelineDateCell!.topBar.isHidden = true
			}
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "EEEE, MMM d"
			if(historyObject.day! as Date > Date()){
				timelineDateCell!.dashLines()
			} 
			if(historyObject.day! as Date == Calendar.current.startOfDay(for: Date())){
				timelineDateCell!.dateLabel.text = "Astazi"
			}else{
				
				timelineDateCell!.dateLabel.text = dateFormatter.string(from: historyObject.day! as Date)
			}
			return timelineDateCell!
		}
		if let historyObject = self.historyDaysAndEntities[indexPath.row] as? HistoryEntity {
			var medicationCell = tableView.dequeueReusableCell(withIdentifier: "MedicationTableViewCell") as? MedicationTableViewCell
			if(medicationCell == nil){
				medicationCell = MedicationTableViewCell()
			}
			medicationCell!.configure(isTaken: historyObject.taken, dotColor: historyObject.medication?.tagColor, hour: Int(historyObject.hour), medName: historyObject.medication?.name)
			return medicationCell!
		}
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
		
		if let historyEntity = historyDaysAndEntities[indexPath.row] as? HistoryEntity {
			
			let alertController = UIAlertController(title: historyEntity.medication?.name!, message: "Opțiuni medicament", preferredStyle: .actionSheet)
			if(historyEntity.taken != .taken){
				alertController.addAction(UIAlertAction(title: "Am luat acest medicament", style: .default, handler: { (action) in
					 historyEntity.taken = .taken
					self.medicationTable.reloadRows(at: [indexPath], with: .fade)
					CoreDataManager.saveMainContext()
				} ))
				alertController.addAction(UIAlertAction(title: "Reprogramează", style: .default, handler: nil))
			}else{
				alertController.addAction(UIAlertAction(title: "Nu am luat acest medicament", style: .default, handler: { (action) in
					let medDate = historyEntity.historyDay!.day! as Date
					if(medDate > Date()){
						historyEntity.taken = .unknown
					}else{
						historyEntity.taken = .notTaken
					}
					self.medicationTable.reloadRows(at: [indexPath], with: .fade)
					CoreDataManager.saveMainContext()
				}))
			}
			alertController.addAction(UIAlertAction(title: "Inchide", style: .cancel, handler: nil))
			self.present(alertController, animated: true, completion: nil)
		}
		
	
	}
    //MARK: Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToAddMedication", sender: sender)
        
    }
    @IBAction func useCodeTapped(_ sender: Any) {
       performSegue(withIdentifier: "goToAddCode", sender: sender)
    }



}

