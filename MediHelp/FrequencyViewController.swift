//
//  FrequencyViewController.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/6/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import UIKit

class FrequencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PickerControllerDelegate {

    @IBOutlet weak var medicationNameLabel: UILabel!
    @IBOutlet weak var medicationDosageLabel: UILabel!
    @IBOutlet weak var timesTableView: UITableView!
    @IBOutlet weak var timesTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var daysTableView: UITableView!
    @IBOutlet weak var daysTableViewHeight: NSLayoutConstraint!
    var selectedFrequency : FrequencyType = .daily
    var selectedTimesPerDay : Int = 1
    var selectedTimes : [Int] = [28800]
    var days : [String] = ["Sâmbătă","Duminică","Luni","Marți","Miercuri","Joi","Vineri"]
    var selectedDays : [Int] = [0,1,2,3,4,5,6]
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var timesTextField: UITextField!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var cotnainerViewTotalHeight: NSLayoutConstraint!
    @IBOutlet weak var intervalView: UIView!
    @IBOutlet weak var intervalTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timesTableView.delegate = self
        timesTableView.dataSource = self
        daysTableView.delegate = self
        daysTableView.dataSource = self
        for index in 0...6 {
            daysTableView.selectRow(at: IndexPath.init(row: index, section: 0), animated: false, scrollPosition: .none)
        }
        
        cotnainerViewTotalHeight.constant = 400
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapFrequency(_ sender: Any) {
        presentPickerWithType(.frequency)
    }
    @IBAction func didTapTimesPerDay(_ sender: Any) {
        presentPickerWithType(.times)
    }
    @IBAction func didTapInterval(_ sender: Any) {
        presentPickerWithType(.interval)
    }
    @IBAction func didTapAdd(_ sender: Any) {
        MediProgressHUD.present(loadingText: "Se adauga...")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            MediProgressHUD.dismiss(delay: 2, message: "Medicament adaugat cu succes", success: true, completion: {
                [unowned self] in
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    func presentPickerWithType(_ pickerType: PickerType) {
        let pickerController = PickerViewController()
        pickerController.pickerType = pickerType
        pickerController.delegate = self
        pickerController.modalPresentationStyle = .overCurrentContext
        tabBarController?.present(pickerController, animated: false, completion: nil)
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
        
        self.selectedTimes[0] = 8*60*60;
        for index in 1...time {
            self.selectedTimes.insert(self.selectedTimes[index-1]+60*60*24/time, at: index)
        }
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
        if(frequency == .interval){
            self.intervalView.isHidden = false
            self.daysLabel.isHidden = false
            self.daysLabel.text = "Interval"
        }
        if(frequency == .specificDays){
            if(self.daysTableView.isHidden == true){
            cotnainerViewTotalHeight.constant = cotnainerViewTotalHeight.constant + 245
            self.daysTableView.isHidden = false
                self.daysLabel.isHidden = false
                self.daysLabel.text = "Zile"
            }
        }
        
    }
    func didSelectInterval(_ interval: Int) {
        self.intervalTextField.text = "Odată la \(String(interval)) zile"
    }
    func didSelectDate(_ date: Date) {
        
    }
    func didSelectHour(secondsFromMidnight: Int) {
        if let selectedIndex = self.timesTableView.indexPathForSelectedRow?.row {
            self.selectedTimes[selectedIndex] = secondsFromMidnight
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
            presentPickerWithType(.hour)
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
