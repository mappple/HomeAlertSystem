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
    
    
    @IBOutlet weak var pirLabel: UILabel!
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
                        self.pirLabel.text = "These is no abnormal situation."
                    } else if data == 1 {
                        self.pirLabel.text = "Detect an abnormal situation!"
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "WHITELIST"
    }
    
    //let aiv = UIActivityIndicatorView(style: .whiteLarge)
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
      
      
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
    

    
//    func getPiName(userId: String?) -> String?{
//        var piName: String?
//        if (userId != nil){
//            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
//                let pi = snapshot.value as? [String:Any]
//                //let pi = snapshot.value as? [String:Any]
//                piName = pi![userId!] as? String
//                self.currentPi = piName!
//                //piName = pi
//            })
//
//            return piName
//        }
//        return nil
//
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
