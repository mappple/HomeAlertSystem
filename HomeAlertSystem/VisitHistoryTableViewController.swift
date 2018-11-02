//
//  VisitHistoryTableViewController.swift
//  HomeAlertSystem
//
//  Created by Ming Yang on 30/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage
import UserNotifications

class VisitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var visitorNameLabel: UILabel!
    @IBOutlet weak var visitDateLabel: UILabel!
    @IBOutlet weak var visitorImage: UIImageView!
    
    override func prepareForReuse() {
        visitorNameLabel.textColor = UIColor.white
    }
    
}

class VisitHistoryTableViewController: UITableViewController {

    private let ref = Database.database().reference()
    private let storage = Storage.storage()
    private var dataRefHandle: DatabaseHandle?
    var sections = Dictionary<Int, Array<Visit>>()
    var sortedSections = [Int]()
    var tabVC: BaseTabBarController?
    var piName = ""
    let uid = Auth.auth().currentUser?.uid
    private func observeNewVisit(piName: String)
    {
        dataRefHandle = ref.child("\(piName)/data").observe(.childAdded, with: {(snapshot) -> Void in
            let data = snapshot.value as! Dictionary<String, Any>
            if let id = data["id"] as! String?, let strTime = data["time"] as! String?, let intTime = Int(strTime), let strUrl = data["url"] as! String?, let url = URL(string: strUrl){
                let time = Date(timeIntervalSince1970: (Double(intTime) / 1000.0))
                if id == "0" {
                    self.setUserNotification()
                }
                let day = Int(Double(intTime) / 1000.0 / 3600 / 24)
                if self.sections.index(forKey: day) == nil {
                    self.sections[day] = [Visit(id: id, time: time, url: url)]
                } else {
                    self.sections[day]!.append(Visit(id: id, time: time, url: url))
                }
                self.sections[day] = self.sections[day]!.sorted(by: { $0.time > $1.time })
                self.sortedSections = self.sections.keys.sorted(by: >)

                self.tableView.reloadData()
            } else {
                print("Error for data reference observer")
            }
        })
    }
    
    // Remove all observers when deinitializing
    deinit {
        if let dataHandle = dataRefHandle {
            ref.removeObserver(withHandle: dataHandle)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImage(named: "night-stars-wallpaper-1")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        self.tableView.backgroundView?.contentMode = .scaleAspectFill
        tabVC = self.tabBarController as? BaseTabBarController
        if (uid != nil){
            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? [String:Any]
                //let pi = snapshot.value as? [String:Any]
                self.piName = (value![self.uid!] as? String)!
                self.observeNewVisit(piName: self.piName)
            })
        }
    }
    
    // Set notificaiton center content
    func setUserNotification() {
        let content = UNMutableNotificationContent()
        content.title = "ALERT!"
        content.sound = UNNotificationSound.default
        content.body = "DETECT THE PRESENCE OF A STRANGER!"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "cold", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

    }
    

    //Return the number days which contains alert data
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    //Return the number of alert data in each day
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[sortedSections[section]]!.count
    }
    
    //Return the section name of time in Australia format
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let time = Date(timeIntervalSince1970: Double(sortedSections[section] * 24 * 3600))
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        return df.string(from: time)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .white
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitCell", for: indexPath) as! VisitTableViewCell
        let visitSection = sections[sortedSections[indexPath.section]]
        let visitor = visitSection![indexPath.row]
        let tabVC = self.tabBarController as! BaseTabBarController
        if visitor.id == "0" {
            cell.visitorNameLabel.textColor = UIColor.red
        }
        if tabVC.acDict != nil {
            cell.visitorNameLabel.text = tabVC.acDict![Int(visitor.id)!]
        } else {
            cell.visitorNameLabel?.text = visitor.id
        }
        
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        let dateString = df.string(from: visitor.time)
        cell.visitDateLabel?.text = dateString
        cell.visitorImage.sd_setImage(with: visitor.url, placeholderImage: UIImage(named: "loading"), options: SDWebImageOptions.continueInBackground) { (image:UIImage?, error:Error?, cacheType: SDImageCacheType, url:URL?) in
            let itemSize = CGSize.init(width: 320, height: 180)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
            let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
            cell.visitorImage.image?.draw(in: imageRect)
            cell.visitorImage.image = UIGraphicsGetImageFromCurrentImageContext()!;
            UIGraphicsEndImageContext();
        }
        return cell
    }
}

