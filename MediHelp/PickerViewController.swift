//
//  PickerViewController.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/6/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import UIKit
enum  PickerType{
    case frequency, hour, date, times, interval
}
enum FrequencyType{
    case daily,specificDays,interval,asNeeded
}
protocol PickerControllerDelegate {
    func didSelectFrequencyType(_ frequency : FrequencyType)
    func didSelectHour(secondsFromMidnight: Int)
    func didSelectDate(_ date : Date)
    func didSelectTimesPerDay(_ time : Int)
    func didSelectInterval(_ interval : Int)
}
class PickerViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    var delegate : PickerControllerDelegate?
    var pickerType : PickerType = .frequency
    let frequencyArray : [FrequencyType] = [.daily,.specificDays,.interval,.asNeeded]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 8.0
        
        //Configure picker depending on loaded type
        titleLabel.text = ""
        switch pickerType {
        case .frequency, .times, .hour, .interval:
            pickerView.delegate = self
            pickerView.dataSource = self
            datePickerView.isHidden = true
            break;
        case .date:
            datePickerView.isHidden = false
            datePickerView.datePickerMode = .date
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundView.alpha = 0
        self.containerBottomConstraint.constant = 28
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            [unowned self] in
            self.view.layoutIfNeeded()
            self.backgroundView.alpha = 0.4

            }, completion: { (success) in
                self.containerBottomConstraint.constant=15
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Actions
    @IBAction func chooseButtonTapped(_ sender: Any) {
        //pass data to delegate
        
        switch pickerType {
        case .times:
            delegate?.didSelectTimesPerDay(pickerView.selectedRow(inComponent: 1)+1)
        case .frequency:
            delegate?.didSelectFrequencyType(frequencyArray[pickerView.selectedRow(inComponent: 0)])
        case .hour:
            delegate?.didSelectHour(secondsFromMidnight:pickerView.selectedRow(inComponent: 0)*60*60 + pickerView.selectedRow(inComponent: 1)*60)
        case .date:
            delegate?.didSelectDate(datePickerView.date)
        case .interval:
            delegate?.didSelectInterval(pickerView.selectedRow(inComponent: 1)+2)
        }
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: - PickerView Delegate &DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerType {
        case .frequency:
            return 1
        case .times,.interval:
            return 3
        case .hour:
            return 2
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerType {
        case .frequency:
            return frequencyArray.count
        case .times:
            switch component {
            case 0:
                return 1
            case 1:
                return 24
            case 2:
                return 1
            default:
                return 0
            }
        case .interval:
            switch component {
            case 0:
                return 1
            case 1:
                return 28
            case 2:
                return 1
            default:
                return 0
            }
        case .hour:
            switch component {
            case 0:
                return 24
            case 1:
                return 60
            default:
                return 0
            }
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerType {
        case .frequency:
            return stringForFrequency(frequency: frequencyArray[row])
        case .times:
            switch component {
            case 0:
                return "De"
            case 1:
                return String(row+1)
            case 2:
                return "ori pe zi"
            default:
                return ""
            }
        case .interval:
            switch component {
            case 0:
                return "La fiecare"
            case 1:
                return String(row+2)
            case 2:
                return "Zile"
            default:
                return ""
            }
        case .hour:
            switch component {
            case 0,1:
                if row<10 {
                    return "0\(String(row))"
                }else {
                    return String(row)
                }
            default:
                return ""
            }
        default:
            return ""
        }
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
    
    
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
