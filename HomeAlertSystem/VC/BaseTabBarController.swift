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
    var piName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
