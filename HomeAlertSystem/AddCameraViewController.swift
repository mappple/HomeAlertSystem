//
//  AddCameraViewController.swift
//  HomeAlertSystem
//
//  Created by Mappple on 26/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import CoreData
//import RSKImageCropper

class AddCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!

    
    var appDelegate: AppDelegate?
    var managedObjectContext: NSManagedObjectContext?
    //var tabBar : BaseTabBarController?
    var imagePicker: UIImagePickerController!
    var name: String?
    var numOfUser: Int?
    var gallerySize: Int?
    
    @IBAction func takePhoto(_ sender: Any) {
        guard numOfUser != nil else {
            displayMessage("Please input a name before take photo", "Error")
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
        }
        else {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        }

        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func savePhoto(_ sender: Any) {
        guard let image = imageView.image else {
            displayMessage("Cannot save until a photo has been taken", "Error")
            return
        }
        
        //let date = UInt(Date().timeIntervalSince1970)
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("User.\(numOfUser! + 1).\(gallerySize! + 1)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
            let newImage = NSEntityDescription.insertNewObject(forEntityName: "ImageMetaData", into: managedObjectContext!) as! ImageMetaData
            newImage.fileName = "User.\(numOfUser! + 1).\(gallerySize! + 1)"
            do {
                try self.managedObjectContext?.save()
                displayMessage("Image has been saved!", "Success")
            } catch {
                displayMessage("Could not save image", "Error")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        displayMessage("There was an error in getting the photo", "Error")
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayMessage(_ message: String, _ title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil ))
        self.present(alertController, animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
//        picker.dismiss(animated: false) {
//
//            var imageCropVC : RSKImageCropViewController!
//
//            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
//
//            imageCropVC.delegate = self as? RSKImageCropViewControllerDelegate
//
//            self.navigationController?.pushViewController(imageCropVC, animated: true)
//
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
