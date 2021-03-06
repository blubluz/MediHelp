//
//  FrequencyViewController.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/6/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import UIKit
import CoreData
class FrequencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PickerControllerDelegate {

    @IBOutlet weak var medicationNameLabel: UILabel!
    @IBOutlet weak var medicationDosageLabel: UILabel!
    @IBOutlet weak var timesTableView: UITableView!
    @IBOutlet weak var timesTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var daysTableView: UITableView!
    @IBOutlet weak var daysTableViewHeight: NSLayoutConstraint!
	var medName : String?
	var medDosage : String?
    var selectedFrequency : FrequencyType = .daily
    var selectedTimesPerDay : Int = 1
    var selectedTimes : [Int] = [28800]
    var days : [String] = ["Sâmbătă","Duminică","Luni","Marți","Miercuri","Joi","Vineri"]
    var selectedDays : [Int] = [0,1,2,3,4,5,6]
    var medication : Medication?
    var comingFromEdit : Bool = false
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var timesTextField: UITextField!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var cotnainerViewTotalHeight: NSLayoutConstraint!
    @IBOutlet weak var intervalView: UIView!
    @IBOutlet weak var intervalTextField: UITextField!
    @IBOutlet weak var startingWithLabel: UILabel!
    @IBOutlet weak var startingWithButton: UIButton!
    @IBOutlet weak var untilLabel: UILabel!
    @IBOutlet weak var untilButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
	
        self.medicationNameLabel.text = medName
		self.medicationDosageLabel.text = medDosage
        timesTableView.delegate = self
        timesTableView.dataSource = self
        daysTableView.delegate = self
        daysTableView.dataSource = self
        for index in 0...6 {
            daysTableView.selectRow(at: IndexPath.init(row: index, section: 0), animated: false, scrollPosition: .none)
        }
        daysTableViewHeight.constant = 0
        cotnainerViewTotalHeight.constant = 500
        
        if(comingFromEdit){
            //TODO: Setup the controller accordingly
        }else {
			let frequency = Frequency(entity: NSEntityDescription.entity(forEntityName: "Frequency", in: CoreDataManager.mainViewContext)!, insertInto: CoreDataManager.mainViewContext)
			medication?.frequency = frequency
			medication?.frequency?.timesPerDay = 1
            medication?.frequency?.times = selectedTimes
            medication?.frequency?.days = selectedDays
            medication?.startDate = Date() as NSDate
            medication?.endDate = nil
            
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Button actions
    @IBAction func didTapFrequency(_ sender: Any) {
        presentPickerWithType(.frequency, nil)
    }
    @IBAction func didTapTimesPerDay(_ sender: Any) {
        presentPickerWithType(.times, nil)
    }
    @IBAction func didTapInterval(_ sender: Any) {
        presentPickerWithType(.interval, nil)
    }
    @IBAction func didTapAdd(_ sender: Any) {
        MediProgressHUD.present(loadingText: "Se adauga...")
        if(self.selectedFrequency == .specificDays){
            medication?.frequency?.days = selectedDays
        }
		
        CoreDataManager.generateNewHistoryFor(medication: medication!)
        
        
        let treatmentVc = self.navigationController?.viewControllers[0] as! TreatmentViewController
        treatmentVc.medicationTable.isHidden = false

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            MediProgressHUD.dismiss(delay: 2, message: "Medicament adaugat cu succes", success: true, completion: {
                [unowned self] in
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    @IBAction func startingWithTapped(_ sender: Any) {
        presentPickerWithType(.date, sender)
    }
    @IBAction func untilTapped(_ sender: Any) {
        presentPickerWithType(.date, sender)

    }
    func presentPickerWithType(_ pickerType: PickerType, _ sender: Any?) {
        let pickerController = PickerViewController()
        pickerController.pickerType = pickerType
        pickerController.delegate = self
        pickerController.sender = sender
        pickerController.modalPresentationStyle = .overCurrentContext
        navigationController?.present(pickerController, animated: false, completion: nil)
    }
    func stringForFrequency(frequency : FrequencyType) -> String {
        switch frequency {
        case .daily:
            return "Zilnic"
        case .specificDays:
            return "Anumite zile"
        case .asNeeded:
            return "Dupa nevoie"
        case .interval:
            return "Interval"
        }
    }
    
    //MARK: - PickerController Delegate
    func didSelectTimesPerDay(_ time: Int) {
        self.selectedTimesPerDay = time
        if(time == 1){
            self.timesTextField.text = "Odata pe zi"
        }
        else{
            self.timesTextField.text = "De \(String(selectedTimesPerDay)) ori pe zi"
        }
        var height = 400 as CGFloat
        if(selectedFrequency == .specificDays){
            height  = height + 245
        }
        cotnainerViewTotalHeight.constant = height + CGFloat(35.0 * Double(selectedTimesPerDay))
        selectedTimes = []
		selectedTimes.insert(8*60*60, at: 0)
		if(time>1){
        for index in 1...time-1 {
            self.selectedTimes.insert(self.selectedTimes[index-1]+60*60*24/time, at: index)
        }
		}
        medication?.frequency?.timesPerDay = Int64(time)
        medication?.frequency?.times = selectedTimes

        self.timesTableView.reloadData()
        
    }
    func didSelectFrequencyType(_ frequency: FrequencyType) {
        if(selectedFrequency == .specificDays && selectedFrequency != frequency){
            cotnainerViewTotalHeight.constant = cotnainerViewTotalHeight.constant - 245
        }

        selectedFrequency = frequency
        frequencyTextField.text = stringForFrequency(frequency: frequency)
        self.intervalView.isHidden = true
        self.daysLabel.isHidden = true
        self.daysTableView.isHidden = true
        if(frequency == .daily){
            medication?.frequency?.intervalAmount = 0
            medication?.frequency?.days =  [0,1,2,3,4,5,6]
            
        }
        if(frequency == .interval){
            medication?.frequency?.intervalAmount = 2
            medication?.frequency?.days = nil
            
            self.intervalView.isHidden = false
            self.daysLabel.isHidden = false
            self.daysLabel.text = "Interval"
        }
        if(frequency == .specificDays){
            medication?.frequency?.intervalAmount = 0
            daysTableViewHeight.constant = 245
            if(self.daysTableView.isHidden == true){
            cotnainerViewTotalHeight.constant = cotnainerViewTotalHeight.constant + daysTableViewHeight.constant + 30
            self.daysTableView.isHidden = false
                self.daysLabel.isHidden = false
                self.daysLabel.text = "Zile"
            }
        }else{
            daysTableViewHeight.constant = 0
        }
        
    }
    func didSelectInterval(_ interval: Int) {
        self.intervalTextField.text = "Odată la \(String(interval)) zile"
        medication?.frequency?.intervalAmount = Int16(interval)
    }
    func didSelectDate(_ date: Date, _ sender : Any?) {
        
        if let sender = sender as? UIButton {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
            switch sender {
            case untilButton:
                medication?.endDate = date as NSDate
                untilButton.setTitle(dateFormatter.string(from: date), for: .normal)
            case startingWithButton:
                medication?.startDate = date as NSDate
                startingWithButton.setTitle(dateFormatter.string(from: date), for: .normal)
            default:
                return
            }
        }
        
    }
    func didSelectHour(secondsFromMidnight: Int) {
        if let selectedIndex = self.timesTableView.indexPathForSelectedRow?.row {
            self.selectedTimes[selectedIndex] = secondsFromMidnight
            medication?.frequency?.times = selectedTimes
            self.timesTableView.reloadRows(at: [IndexPath(row: selectedIndex, section: 0)], with: .none)
        }
    }
    //MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35	
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == daysTableView){
            return 7
        }
        timesTableViewHeight.constant = CGFloat(35.0 * Double(selectedTimesPerDay))
        return selectedTimesPerDay
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == daysTableView){
            var cell = tableView.dequeueReusableCell(withIdentifier: "DaysTableViewCell") as? DaysTableViewCell
            if(cell == nil){
                cell = DaysTableViewCell()
            }
            if(selectedDays.contains(indexPath.row)){
                cell?.checkMark.isHidden = false
            }else{
                cell?.checkMark.isHidden = true
            }
            cell!.cellTextField.text = days[indexPath.row]
            return cell!
            
        }
        else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "TimeTableViewCell") as? TimeTableViewCell
            if(cell == nil){
                cell = TimeTableViewCell()
            }
            let hours = String(selectedTimes[indexPath.row]/3600 % 24)
            let minutes = String(format: "%02d", (selectedTimes[indexPath.row] - ((selectedTimes[indexPath.row]/3600) * 3600) ) / 60)
            cell!.cellTextField.text = "\(hours):\(minutes)"
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == timesTableView){
            presentPickerWithType(.hour, nil)
        }
        if(tableView == daysTableView){
            selectedDays.append(indexPath.row)
        }
        //TODO: preselect picker on the correct hour
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if(tableView == daysTableView){
            if let index = selectedDays.index(of: indexPath.row) {
                selectedDays.remove(at: index)
            }
        }
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
