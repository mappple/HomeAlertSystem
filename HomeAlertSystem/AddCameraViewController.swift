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
            imagePicker.cameraFlashMode = UIImagePickerController.CameraFlashMode.off
            imagePicker.cameraDevice = UIImagePickerController.CameraDevice.front
        }
        else {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        }

        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func convertToGrayScale(image: UIImage) -> UIImage {
        let imageRect:CGRect = CGRect(x:0, y:0, width:image.size.width, height: image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        //have to draw before create image
        
        context?.draw(image.cgImage!, in: imageRect)
        let imageRef = context!.makeImage()
        let newImage = UIImage(cgImage: imageRef!)
        
        return newImage
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
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let newImage = convertToGrayScale(image: pickedImage)
            imageView.image = resizeImage(image: newImage, targetSize: CGSize(width: 200.0, height: 200.0))
        }
        dismiss(animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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

