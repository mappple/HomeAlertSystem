//
//  AddCameraViewController.swift
//  HomeAlertSystem
//
//  Created by Mappple on 26/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import CoreData

class AddCameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var appDelegate: AppDelegate?
    var managedObjectContext: NSManagedObjectContext?
    var imagePicker: UIImagePickerController!
    var name: String?
    var numOfUser: Int?
    var gallerySize: Int?
    
    @IBOutlet weak var imageView: UIImageView!
    /*
     Call image picker if available
     */
    @IBAction func takePhoto(_ sender: Any) {
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
    
    /*
     Save photo to core data
     */
    @IBAction func savePhoto(_ sender: Any) {
        guard let image = imageView.image else {
            displayMessage("Cannot save until a photo has been taken", "Error")
            return
        }
        let date = UInt(Date().timeIntervalSince1970)
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("\(date)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
            let newImage = NSEntityDescription.insertNewObject(forEntityName: "ImageMetaData", into: managedObjectContext!) as! ImageMetaData
            newImage.fileName = "\(date)"
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
        self.setBackgroundImage("night-stars-wallpaper-1", contentMode: .scaleAspectFill)
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
    }

    /*
     Resize photo to 200x200
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let newImage = convertToGrayScale(image: pickedImage)
            imageView.image = resizeImage(image: newImage, targetSize: CGSize(width: 200.0, height: 200.0))
        }
        dismiss(animated: true, completion: nil)
    }
    
    /*
     Convert photo to gray scale to increase accuracy when performing face detection
     */
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
    
    /*
     Function to resize photo to 200x200
     */
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
    
}

