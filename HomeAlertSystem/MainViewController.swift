//
//  MainViewController.swift
//  HomeAlertSystem
//
//  Created by Mappple on 23/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseStorage



class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch{
            
        }
        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = signInPage
    }
    
    private var ref = Database.database().reference()
    
    private var acquaintanceRefHandle: DatabaseHandle?
    
    
    private var acquaintanceDictionary: [Int: String] = [:]
    let uid = Auth.auth().currentUser?.uid
    var tabVC: BaseTabBarController?
    
    
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    private func observeNewAcquaintance(raspberryPiName: String)
    {
        acquaintanceRefHandle = getAcquaintanceRefByPiName(raspberryPiName: raspberryPiName).observe(.childAdded, with: {(snapshot) -> Void in
            
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
    
    
    /*
     Remove all observers when deinitializing
     */
    deinit {
        
    
        
        if let acquaintanceHandle = acquaintanceRefHandle, let raspberryPiName = getPiName(userId: uid){
            
            getAcquaintanceRefByPiName(raspberryPiName: raspberryPiName).removeObserver(withHandle: acquaintanceHandle)
            
            
        }
    }
    
    
    @IBOutlet weak var acquaintanceTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return acquaintanceDictionary.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "acquaintanceCell", for: indexPath)
        cell.textLabel?.text = acquaintanceDictionary[indexPath.row + 1]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Current Acquaintance List"
    }
    
    //let aiv = UIActivityIndicatorView(style: .whiteLarge)
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete, let raspberryPiName = getPiName(userId: uid) {
            // Delete the row from the data source
            acquaintanceDictionary.removeValue(forKey: indexPath.row + 1)
            let newACNum = acquaintanceDictionary.count
            let updateACNameList = ["/\(raspberryPiName)/acquaintance/list/number": newACNum]
            ref.updateChildValues(updateACNameList)
            
            getAcquaintanceRefByPiName(raspberryPiName: raspberryPiName).child(String(indexPath.row + 1)).removeValue()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the table view cell class and its reuse id
        self.acquaintanceTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        acquaintanceTableView.delegate = self
        acquaintanceTableView.dataSource = self
        
        
       
        
        
        //Configure observer for the raspberryPiName if the raspberryPiName exists
        
        if let raspberryPiName = getPiName(userId: uid){
            
            observeNewAcquaintance(raspberryPiName: raspberryPiName)
            self.acquaintanceTableView.reloadData()
           
        }
        print("pi name::::::::::::::::::")
        print (getPiName(userId: uid))
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
        
    }
    

    
    func getPiName(userId: String?) -> String?{
        
        var piName: String?
        if (userId != nil){
            Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                
                let pi = snapshot.value as? [String:Any]
                //let pi = snapshot.value as? [String:Any]
                piName = pi![userId!] as? String
                //piName = pi
            })
            return piName
        }
        return nil
        
    }
    
    func getAcquaintanceRefByPiName(raspberryPiName: String) -> DatabaseReference{
        let acquaintanceRef = Database.database().reference().child("\(raspberryPiName)/acquaintance")
        return acquaintanceRef
    }
    
//    private func observeNewAcquaintance(raspberryPiName: String)
//    {
//
//        acquaintanceRefHandle = getAcquaintanceRefByPiName(raspberryPiName: raspberryPiName)
//            .observe(.childAdded, with: {(snapshot) -> Void in
//                if snapshot.exists(){
//
//                    if self.isStringAnInt(string: snapshot.key) == true && Int(snapshot.key) != 0{
//                        let data = snapshot.value as! Dictionary<String, Any>
//                        if let name = data["name"] as! String?, let index = snapshot.key as String?{
//                            self.acquaintanceDictionary[Int(index)!] = name
//                            self.acquaintanceTableView.reloadData()
//                        } else {
//                            print("Error for data reference observer")
//                        }
//                    }
//                } else {
//                    print ("The aiming firebase path is nil!")
//                }
//            })
//    }
    

    
   
    
   
    //    func setupPlayer() {
    //
    //
    //
    //
    //        //let videoURL = URL(string: "http://172.20.10.9:8080/camera/livestream.m3u8")
    //        let videoURL = URL(string: "http://192.168.2.145:8080/camera/livestream.m3u8")
    //        let player = AVPlayer(url: videoURL!)
    //        let playerLayer = AVPlayerLayer(player: player)
    //        let height = self.view.frame.width * 9 / 16
    //        let playerFrame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: height)
    //        playerLayer.frame = playerFrame
    //
    //        let videoView = UIView(frame: playerFrame)
    //
    //        videoView.backgroundColor = UIColor.black
    //        videoView.layer.addSublayer(playerLayer)
    //
    //        self.view.addSubview(videoView)
    //        player.play()
    //
    //        player.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
    //
    //        let controlsContainerView: UIView = {
    //            let view = UIView()
    //            //view.backgroundColor = UIColor(white: 1, alpha: 0.5)
    //            return view
    //        }()
    //
    //
    //        aiv.translatesAutoresizingMaskIntoConstraints = false
    //        aiv.startAnimating()
    //        controlsContainerView.frame = playerFrame
    //        self.view.addSubview(controlsContainerView)
    //
    //        controlsContainerView.addSubview(aiv)
    //        aiv.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
    //        aiv.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
    //
    //
    //
    //    }
    
    
    //    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    //        if keyPath == "currentItem.loadedTimeRanges" {
    //            aiv.stopAnimating()
    //
    //        }
    //    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
