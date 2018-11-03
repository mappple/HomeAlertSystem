//
//  MainViewController.swift
//  HomeAlertSystem
//
//  Created by Mappple on 23/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage



class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    func setUpSettingButton(){
        let moreButton = UIBarButtonItem(image: UIImage(named: "setting"), style: .plain, target: self, action: #selector(handleMore(sender: )))
        navigationItem.leftBarButtonItem = moreButton
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    let settingsLauncher = SettingsLauncher()
    
    
    
    @objc func handleMore(sender: UIBarButtonItem){
        settingsLauncher.mainViewController = self
        settingsLauncher.showSettings(sender: navigationItem.leftBarButtonItem!)
        
        
    }
    
    func showControllerForSettingsLauncher(){
        
        let aboutPageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutPageViewController") as! AboutPageViewController
        
        navigationController?.pushViewController(aboutPageViewController, animated: true)
    }
    
    func signOutForSettingLauncher(){
        
        do {
            try Auth.auth().signOut()
        } catch{
            
        }
        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = signInPage
        
    }
    
    
    @IBOutlet weak var pirLabel: UILabel!
    
    private var ref = Database.database().reference()
    private var acquaintanceRefHandle: DatabaseHandle?
    private var pirRefHandle: DatabaseHandle?
    private var acquaintanceDictionary: [Int: String] = [:]
    let uid = Auth.auth().currentUser?.uid
    var piName = ""
    var tabVC: BaseTabBarController?
    @IBOutlet weak var acquaintanceTableView: UITableView!
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    private func observeNewAcquaintance(piName: String){
        if piName != ""{
            acquaintanceRefHandle = ref.child("\(piName)/acquaintance").observe(.childAdded, with: {(snapshot) -> Void in
                if self.isStringAnInt(string: snapshot.key) == true {
                    let data = snapshot.value as! Dictionary<String, Any>
                    if let name = data["name"] as! String?, let index = snapshot.key as String?{
                        self.acquaintanceDictionary[Int(index)!] = name
                        self.acquaintanceTableView.reloadData()
                        self.tabVC = self.tabBarController as? BaseTabBarController
                        self.tabVC!.acDict = self.acquaintanceDictionary
                    } else {
                        print("Error for data reference observer")
                    }
                }
            })
            
        }
    }
    
    private func observePIR(piName: String){
        if piName != ""{
            pirRefHandle = ref.child("\(piName)/pir/pirstate").observe(.value, with: {(snapshot) -> Void in
                    let data = snapshot.value as! Int
                    if data == 0 {
                        self.pirLabel.text = "Congratulation! These is no abnormal situation."
                        self.pirLabel.textColor = UIColor.white
                    } else if data == 1 {
                        self.pirLabel.text = "Be Careful! PIR sensor detect an abnormal situation!"
                        self.pirLabel.textColor = UIColor.red
                    }
                    
                    
            })
            
        }
    }
    
    
    /*
     Remove all observers when deinitializing
     */
    deinit {
        ref.removeAllObservers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acquaintanceDictionary.count - 1
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "acquaintanceCell", for: indexPath)
        cell.textLabel?.text = acquaintanceDictionary[indexPath.row + 1]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete && piName != "" {
            // Delete the row from the data source
            acquaintanceDictionary.removeValue(forKey: indexPath.row + 1)
            let newACNum = acquaintanceDictionary.count - 1
            let deleteNo = indexPath.row + 1
            let updateACNameList = ["/\(piName)/acquaintance/list/number": newACNum,
                                    "/\(piName)/acquaintance/list/deleteNo": deleteNo] as [String : Any]
            ref.updateChildValues(updateACNameList)
            ref.child("\(piName)/acquaintance").child(String(indexPath.row + 1)).removeValue()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundImage("night-stars-wallpaper-1", contentMode: .scaleAspectFill)
        // Register the table view cell class and its reuse id
        self.acquaintanceTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        acquaintanceTableView.delegate = self
        acquaintanceTableView.dataSource = self
        if (uid != nil){
            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String:Any]
            //let pi = snapshot.value as? [String:Any]
                self.piName = (value![self.uid!] as? String)!
                self.observeNewAcquaintance(piName: self.piName)
                self.observePIR(piName: self.piName)
        })
       
        }
       // self.tabVC = self.tabBarController as? BaseTabBarController
       // self.tabVC!.acDict = self.acquaintanceDictionary
        
        //Configure observer for the raspberryPiName if the raspberryPiName exists
        
        self.acquaintanceTableView.reloadData()
        setUpSettingButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        let videoURL = URL(string: "http://172.20.10.9:8080/camera/livestream.m3u8")
        //        let player = AVPlayer(url: videoURL!)
        //        let playerViewController = AVPlayerViewController()
        //        playerViewController.player = player
        //        self.present(playerViewController, animated: true) {
        //            playerViewController.player!.play()
        //    }
        
        
        
        //setupPlayer()
        //self.acquaintanceTableView.reloadData()
        
    }
    

    

}
