//
//  AddGalleryCollectionViewController.swift
//  HomeAlertSystem
//
//  Created by Mappple on 26/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseStorage

class AddGalleryViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var currentACLabel: UILabel!
    
  
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private let reuseIdentifier = "imageCell"
    private let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    private let itemsPerRow: CGFloat = 3
    
    var imageList = [UIImage]()
    var imagePathList = [String]()
    var appDelegate: AppDelegate?
    var managedObjectContext: NSManagedObjectContext?
    private var ref = Database.database().reference()
    //private var acRef = Database.database().reference().child("pi01").child("acquaintance")
    private var acRefHandle: DatabaseHandle?
    private var storageRef = Storage.storage().reference()
    
    
    @IBAction func uploadButton(_ sender: Any) {
        let acNameList = currentACLabel.text?.trimmingCharacters(in: .whitespaces)
        guard let acName = nameTextField.text?.trimmingCharacters(in: .whitespaces), acName != "" else{
            displayMessage("Please input a name!", "Error")
            return
        }
            
        guard acNameList!.range(of: acName) == nil else {
            displayMessage("The name is already in the databse!", "Error")
            return
        }
            
        guard imageList.count > 1 else {
            displayMessage("Pleaase take at least six photo to ensure accuracy!", "Error")
            return
        }
        for (index, name) in imagePathList.enumerated() {
            
                let data = imageList[index].jpegData(compressionQuality: 0)
                let acStorageRef = storageRef.child("ac/\(name).jpg" )
                let metadata = StorageMetadata()
                metadata.contentType = "image/jepg"
                let uploadTask = acStorageRef.putData(data!, metadata: metadata)
            
            uploadTask.observe(.success) { (snapshot) in
                print("upload \(name) success ")
                if index == self.imageList.count - 1 {
                    self.displayMessage("Upload photo successfully!", "Congratulation")
                }
            }
            
            uploadTask.observe(.failure) { (snapshot) in
                if let error = snapshot.error as NSError? {
                    switch (StorageErrorCode(rawValue: error.code)!) {
                    case .objectNotFound:
                        print("object not found!")
                        break
                    case .unauthorized:
                        print("unauthorized!")
                        break
                    case .cancelled:
                        print("cancelled!")
                        break
                    case .unknown:
                        print("Unknown!")
                        break
                    default:
                        break
                    }
            }
        }
//            acStorageRef.downloadURL(completion: { (url, error) in
//                        guard let downloadURL = url else {
//                            print("firebase upload get url error")
//                            return
//                        }
//                        print(downloadURL)
//                    }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let acRef = ref.child("pi01/acquaintance/list/name")
        acRefHandle = acRef.observe(.value, with: { (snapshot) in
            let currentAC = snapshot.value as? String
            if currentAC != nil {
                self.currentACLabel.text = "Current acquaintance: \(currentAC!)"
            }
        })
        
        do {
            let imageDataList = try managedObjectContext!.fetch(ImageMetaData.fetchRequest()) as [ImageMetaData]
            if(imageDataList.count > 0) {
                for data in imageDataList {
                    let fileName = data.fileName!
                    
                    if imagePathList.contains(fileName) {
                        print("Image already loadedin. Skipping image")
                        continue
                    }
                    
                    if let image = loadImageData(fileName: fileName) {
                        self.imageList.append(image)
                        self.imagePathList.append(fileName)
                        self.collectionView?.reloadSections([0])
                    }
                }
            }
            
        } catch {
            print("Unable to fetch list of parties")
        }
    }
    
    func loadImageData(fileName: String) -> UIImage? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        var image: UIImage?
        if let pathComponent = url.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            let fileData = fileManager.contents(atPath: filePath)
            image = UIImage(data: fileData!)
        }
        
        return image
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        
        cell.backgroundColor = UIColor.lightGray
        cell.imageView.image = imageList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageList.count
    }

    func displayMessage(_ message: String, _ title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil ))
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
