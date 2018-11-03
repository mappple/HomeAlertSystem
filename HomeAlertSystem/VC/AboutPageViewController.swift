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
     To set intro title
     */
    func loadStudentNameTitle(){
        studentNameTitle.text = "Intro:"
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
        let author = "Author: Weijia Tu and Ming Yang"
        let unitcode = "Unit Code: FIT5140"
        let intro = "This application is used to add and delete acquaintances to white list and view history data of the home alert system which is consist of a RaspberryPi with face recognition technique, Firebase and the IOS client."
        textViewForStudentName.text = author + "\n" + unitcode + "\n" + intro
    }
    
    /*
     To set reference text view
     */
    func loadTextViewForReference(){
        let ref0 = "Use SDWebImage to downlaod image from url\nhttps://github.com/SDWebImage/SDWebImage\nFollow Firebase IOS document to upload and download data from firebase\nhttps://firebase.google.com/docs/database/?authuser=0"
        let ref01 = "https://www.youtube.com/watch?v=2kwCfFG5fDA"
        let ref02 = "https://www.youtube.com/watch?v=PNmuTTd5zWc"
        let ref03 = "https://www.youtube.com/watch?v=qNqD-YJZV2M&list=PLdW9lrB9HDw3bMSHtNZNt1Qb9XTMmQzLU&index=11"
        let ref04 = "https://www.youtube.com/watch?v=mQ1R-Zh7VrI&index=13&list=PLdW9lrB9HDw3bMSHtNZNt1Qb9XTMmQzLU"
        let ref05 = "https://www.youtube.com/watch?v=cPEGzqb-Ivk&list=PLdW9lrB9HDw3bMSHtNZNt1Qb9XTMmQzLU&index=8"
        textViewForReference.text = ref0 + "\n" + ref01 + "\n" + ref02 + "\n" + ref03 + "\n" + ref04 + "\n" + ref05
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
        loadReferenceTitle()
        loadTextViewForStudentName()
        loadTextViewForReference()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textViewForReference.setContentOffset(CGPoint.zero, animated: false)
        textViewForStudentName.setContentOffset(CGPoint.zero, animated: false)
    }

}
