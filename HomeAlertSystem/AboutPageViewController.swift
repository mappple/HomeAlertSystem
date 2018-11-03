//
//  AboutPageViewController.swift
//  HomeAlertSystem
//
//  Created by Ming Yang on 2/11/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController {

    
    @IBOutlet weak var studentNameTitle: UILabel!
    
    
    @IBOutlet weak var unitCodeTitle: UILabel!
    

    @IBOutlet weak var referenceTitle: UILabel!
    
    
    @IBOutlet weak var textViewForStudentName: UITextView!
    
    @IBOutlet weak var textViewForUnitCode: UITextView!
    
    @IBOutlet weak var textViewForReference: UITextView!
    
    
    
    
    
    /*
     To set student name title
     */
    func loadStudentNameTitle(){
        studentNameTitle.text = "Student Name:"
        
    }
    
    /*
     To set unit code title
     */
    func loadUnitCodeTitle(){
        unitCodeTitle.text = "Unit Code:"
    }
    
    /*
     To set reference title
     */
    func loadReferenceTitle(){
        referenceTitle.text = "Reference:"
    }
    
    /*
     To set student name text view
     */
    func loadTextViewForStudentName(){
        
        textViewForStudentName.text = "Weijia Tu and Ming Yang"
    }
    
    /*
     To set unit code text view
     */
    func loadTextViewForUnitCode(){
        textViewForUnitCode.text = "FIT5140"
        
        
    }
    
    /*
     To set reference text view
     */
    func loadTextViewForReference(){
        
        let ref01 = "https://www.youtube.com/watch?v=2kwCfFG5fDA"
        let ref02 = "https://www.youtube.com/watch?v=PNmuTTd5zWc"
        let ref03 = "https://www.youtube.com/watch?v=qNqD-YJZV2M&list=PLdW9lrB9HDw3bMSHtNZNt1Qb9XTMmQzLU&index=11"
        let ref04 = "https://www.youtube.com/watch?v=mQ1R-Zh7VrI&index=13&list=PLdW9lrB9HDw3bMSHtNZNt1Qb9XTMmQzLU"
        let ref05 = "https://www.youtube.com/watch?v=cPEGzqb-Ivk&list=PLdW9lrB9HDw3bMSHtNZNt1Qb9XTMmQzLU&index=8"
        
        textViewForReference.text = ref01 + "\n" + ref02 + "\n" + ref03 + "\n" + ref04 + "\n" + ref05
        
        
    }
    
    /*
     To load the about page
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackgroundImage("night-stars-wallpaper-1", contentMode: .scaleAspectFill)
        self.navigationItem.title = "About"
        self.navigationItem.hidesBackButton = true
        loadStudentNameTitle()
        loadUnitCodeTitle()
        loadReferenceTitle()
        
        
        loadTextViewForStudentName()
        loadTextViewForUnitCode()
        loadTextViewForReference()
        
        // Do any additional setup after loading the view.
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
