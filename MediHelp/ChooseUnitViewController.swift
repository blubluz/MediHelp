//
//  ChooseUnitViewController.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/6/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//s

import UIKit
protocol ChooseUnitDelegate {
    func didChooseUnit(unitName : String)
}
class ChooseUnitViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

  
    @IBOutlet weak var tableView: UITableView!
    var delegate : ChooseUnitDelegate?
    let unitsArray : [String] = ["Pastile","mg","ml","Lingurițe","Spray","gr","Picături","Unități"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- TableView Delegate&DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unitsArray.count
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 20;
//        
//    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 20
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UnitsTableViewCell") as? UnitsTableViewCell
        if(cell == nil){
            cell = UnitsTableViewCell(style: .default, reuseIdentifier: "UnitsTableViewCell")

        }
        cell?.cellLabel?.text = unitsArray[indexPath.row]

        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didChooseUnit(unitName: unitsArray[indexPath.row])
        navigationController?.popViewController(animated: true)
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
