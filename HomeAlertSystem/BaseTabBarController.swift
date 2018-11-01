//
//  BaseTabBarController.swift
//  HomeAlertSystem
//
//  Created by Mappple on 23/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase

class BaseTabBarController: UITabBarController {
    var acDict: Dictionary<Int, String>?
    let uid = Auth.auth().currentUser?.uid
    var raspberryPiName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    //Get raspberry pi name based on the current user id
    func getPiName(userId: String?) -> String? {
        var piName: String?
        if (userId != nil){
            Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let pi = snapshot.value as? [String:Any]
                //let pi = snapshot.value as? [String:Any]
                piName = pi![userId!] as? String
                //piName = pi
            }, withCancel: nil)
            return piName
        }
        return nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
