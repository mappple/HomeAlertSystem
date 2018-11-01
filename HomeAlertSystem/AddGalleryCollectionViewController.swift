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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!

    private let reuseIdentifier = "imageCell"
    private let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    private let itemsPerRow: CGFloat = 3
    let uid = Auth.auth().currentUser?.uid
    var imageList = [UIImage]()
    var imagePathList = [String]()
    var appDelegate: AppDelegate?
    var managedObjectContext: NSManagedObjectContext?
    var newACName: String?
    var numOfUser: Int?
    var tabVC: BaseTabBarController?
    var piName = ""
    //var tabBar: BaseTabBarController?
    private var ref = Database.database().reference()
    //private var acRef = Database.database().reference().child("pi01").child("acquaintance")
    private var acRefHandle: DatabaseHandle?
    private var storageRef = Storage.storage().reference()
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBAction func confrimNameAction(_ sender: Any) {
        if nameTextField.text != "" {
            //tabBar?.nameLabelData = nameTextField.text?.trimmingCharacters(in: .whitespaces)
            newACName = nameTextField.text!.trimmingCharacters(in: .whitespaces)
            nameTextField.isEnabled = false
            confirmButton.isEnabled = false
            submitButton.isEnabled = true
        } else {
            displayMessage("Please input a name!", "Error")
        }
    }
    
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitDataAction(_ sender: Any) {
     
        guard imageList.count > 1 else {
            displayMessage("Pleaase take at least six photo to ensure accuracy!", "Error")
            return
        }
        submitButton.isEnabled = false
        for (index, name) in imagePathList.enumerated() {
            
            let data = imageList[index].jpegData(compressionQuality: 0)
            let acStorageRef = storageRef.child("pi01/ac/\(name).jpg" )
            let uploadTask = acStorageRef.putData(data!, metadata: nil) { metadata, error in
                metadata!.contentType = "image/jepg"
                acStorageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print("Error when getting downlaod url!")
                        return
                    }
                        print(downloadURL)
                        let ACNum = self.numOfUser!
                        let stringOfUrl = downloadURL.absoluteString
                        let addPhotoUrl = ["/pi01/acquaintance/\(ACNum)/\(index + 1)": stringOfUrl]
                        self.ref.updateChildValues(addPhotoUrl)
                }
            }
            uploadTask.observe(.success) { (snapshot) in
                print("upload \(name) success ")
                if index == self.imageList.count - 1 {
                    self.displayMessage("Upload photo successfully!", "Congratulation")
                    let ACNum = self.numOfUser!
                    let setPhotoNum = ["/\(self.piName)/acquaintance/\(ACNum)/photoNum": self.imageList.count]
                    self.ref.updateChildValues(setPhotoNum)
                    self.cleanCoreData()
                    self.imageList.removeAll()
                    self.imagePathList.removeAll()
                    self.collectionView?.reloadSections([0])
                    self.nameTextField.text = ""
                    self.submitButton.isEnabled = false
                    self.confirmButton.isEnabled = true
                    self.nameTextField.isEnabled = true
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
            
          
            let newACNum = numOfUser! + 1
            let updateACNameList = [
                                    "/\(self.piName)/acquaintance/list/number": newACNum,
                                    "/\(self.piName)/acquaintance/\(newACNum)/name": newACName!] as [String : Any]

            ref.updateChildValues(updateACNameList)
            
        }

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)
        
        submitButton.isEnabled = false
//        tabVC = self.tabBarController as? BaseTabBarController
//        if tabVC?.piName != nil {
//             piName = (tabVC?.piName)!
//        }
        if (uid != nil){
            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? [String:Any]
                //let pi = snapshot.value as? [String:Any]
                self.piName = (value![self.uid!] as? String)!
                let acRef = self.ref.child("\(self.piName)/acquaintance/list")
                self.acRefHandle = acRef.observe(.value, with: { (snapshot) in
                    let data = snapshot.value as? Dictionary<String, Any>
                    
                    let number = data!["number"] as! Int?
                    
                    
                    self.numOfUser = number
                })
                
            })
            
        }
        
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    deinit {
        ref.removeAllObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.delegate = self
        collectionView.dataSource = self

      
        
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
    
    func cleanCoreData() {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageMetaData")
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext?.execute(batchDeleteRequest)
        } catch {
            print("Clean Coredata failed")
        }
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
    
    
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "passNameSegue") {
            if let destinationVC = segue.destination as? AddCameraViewController {
                destinationVC.name = newACName
                destinationVC.numOfUser = numOfUser
                destinationVC.gallerySize = imageList.count
            }
        }
    }
 
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



