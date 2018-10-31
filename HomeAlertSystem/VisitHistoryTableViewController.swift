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


class VisitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var visitorNameLabel: UILabel!
    @IBOutlet weak var visitDateLabel: UILabel!
    @IBOutlet weak var visitorImage: UIImageView!
    
    override func prepareForReuse() {
      //  visitorImage.sd_cancelCurrentImageLoad()
      //  visitorImage.image = nil
    }
    
}



class VisitHistoryTableViewController: UITableViewController {

    private let dataRef = Database.database().reference().child("pi01/data")
    private let storage = Storage.storage()
    //var tabVC: BaseTabBarController?
    private var dataRefHandle: DatabaseHandle?
    //private var visitList: [Visit] = []
    //var sectionMark: Int?
    var sections = Dictionary<String, Array<Visit>>()
    var sortedSections = [String]()
    
    //private var tableParam: [TableElementParam] = []
    
    private func observeNewVisit()
    {
        dataRefHandle = dataRef.observe(.childAdded, with: {(snapshot) -> Void in
            let data = snapshot.value as! Dictionary<String, Any>
            if let id = data["id"] as! String?, let strTime = data["time"] as! String?, let intTime = Int(strTime), let strUrl = data["url"] as! String?, let url = URL(string: strUrl){
                //sectionMark is used to split data into different groups for different days
               //self.sectionMark = Int(Double(intTime) / 1000.0 / 3600 / 24)
                let time = Date(timeIntervalSince1970: (Double(intTime) / 1000.0))
               // let data = try? Data(contentsOf: url)
                
                
                //let imageDefault = UIImage(named: "blank")
                //let image = UIImage(data: data!)
                
                let df = DateFormatter()
                df.dateFormat = "dd-MM-yyyy"
                let day = df.string(from: time)
                //self.visitList.append(Visit(id: id, time: time, url: url))
                if self.sections.index(forKey: day) == nil {
                    self.sections[day] = [Visit(id: id, time: time, url: url)]
                } else {
                    self.sections[day]!.append(Visit(id: id, time: time, url: url))
                }
               
                self.sortedSections = self.sections.keys.sorted(by: >)
                //self.visitList.sort() {$0.time > $1.time}
                
              //  if (self.tableParam == nil){
              //      let tableElementParam = TableElementParam(sectionMark: self.sectionMark!, numOfRows: 1)
//                    self.tableParam.append(tableElementParam)
//                } else {
//                    var i = 0
//                    for item in self.tableParam {
//                        if (item.sectionMark == self.sectionMark){
//                            item.numOfRows = item.numOfRows + 1
//                            i = i + 1
//                        }
//                    }
//                    if (i == 0){
//                        let tableElementParam = TableElementParam(sectionMark: self.sectionMark!, numOfRows: 1)
//                        self.tableParam.append(tableElementParam)
//                    }
//                    self.tableParam.sort() {$0.sectionMark > $1.sectionMark}
//                }
//
                self.tableView.reloadData()
            } else {
                print("Error for data reference observer")
            }
            
            
        })
        
        
    }
    
    /*
     Remove all observers when deinitializing
     */
    deinit {
        if let dataHandle = dataRefHandle {
            dataRef.removeObserver(withHandle: dataHandle)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        observeNewVisit()
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return sections.count
    }
//
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        for i in 0..<tableParam.count{
//            if (section == i){
//                return tableParam[i].numOfRows
//            }
//        }
        return sections[sortedSections[section]]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedSections[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitCell", for: indexPath) as! VisitTableViewCell
        //let cell = tableView.cellForRow(at: indexPath) as! VisitTableViewCell
        
        //let visitor = visitList[indexPath.row]
        let visitSection = sections[sortedSections[indexPath.section]]
        let visitor = visitSection![indexPath.row]
        let tabVC = self.tabBarController as! BaseTabBarController
        if tabVC.acDict != nil {
            cell.visitorNameLabel.text = tabVC.acDict![Int(visitor.id)!]
        } else {
            cell.visitorNameLabel?.text = visitor.id
        }
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let dateString = df.string(from: visitor.time)
        cell.visitDateLabel?.text = dateString
        cell.visitorImage.sd_setImage(with: visitor.url, placeholderImage: UIImage(named: "loading"), options: SDWebImageOptions.continueInBackground) { (image:UIImage?, error:Error?, cacheType: SDImageCacheType, url:URL?) in
            let itemSize = CGSize.init(width: 320, height: 180)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
            let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
            cell.visitorImage.image?.draw(in: imageRect)
            cell.visitorImage.image = UIGraphicsGetImageFromCurrentImageContext()!;
            UIGraphicsEndImageContext();
            //tableView.reloadRows(at: [indexPath], with: .fade)
            
        }
//        cell.visitorImage.sd_setImage(with: visitor.url) { (image:UIImage?, error:Error?, cacheType: SDImageCacheType, url:URL?) in
//            let itemSize = CGSize.init(width: 320, height: 180)
//            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
//            let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
//            cell.visitorImage.image?.draw(in: imageRect)
//            cell.visitorImage.image = UIGraphicsGetImageFromCurrentImageContext()!;
//            UIGraphicsEndImageContext();
//            //tableView.reloadRows(at: [indexPath], with: .fade)
//
//        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

