//
//  MediProgressHUD.swift
//  MediHelp
//
//  Created by Honceiru Mihai on 1/8/18.
//  Copyright © 2018 Honceiru Mihai. All rights reserved.
//

import UIKit

class MediProgressHUD: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingFinishedImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    static var progressHud : MediProgressHUD = {
       let progressHud = MediProgressHUD()
        progressHud.modalPresentationStyle = .overCurrentContext
        return progressHud
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    public class func present(loadingText : String){
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        while (rootViewController?.presentedViewController != nil) {
            rootViewController = rootViewController?.presentedViewController
        }

        rootViewController?.present(progressHud, animated: false, completion: nil)
        
        progressHud.backgroundView.alpha = 0.0
        UIView.animate(withDuration: 0.7) { 
            progressHud.backgroundView.alpha = 0.15
        }
        progressHud.loadingFinishedImageView.isHidden = true
        progressHud.loadingLabel.text = loadingText
        progressHud.activityIndicator.startAnimating()
          }
    public class func dismiss(){
        
        
        //TODO: Animations
        progressHud.dismiss(animated: false, completion: nil)
    }
    public class func dismiss(delay: Int, message : String, success : Bool, completion: @escaping ()->Void) {
        
        progressHud.activityIndicator.stopAnimating()
        progressHud.loadingFinishedImageView.image = UIImage(named: "ic_check")
        progressHud.loadingLabel.text = message
        progressHud.loadingLabel.textColor = UIColor.green
        progressHud.loadingFinishedImageView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            dismiss()
            completion()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
