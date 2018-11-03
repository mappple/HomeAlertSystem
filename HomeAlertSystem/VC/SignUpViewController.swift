//
//  SignUpViewController.swift
//  HomeAlertSystem
//
//  Created by Ming Yang on 24/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class SignUpViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext?
    let ref = Database.database().reference()
    var newUserData: String?
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var raspberryPiNameTextField: UITextField!
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    /*
     To sign up the user to the preferred raspberry pi when sign up button is tapped
     */
    @IBAction func signUpConfirmButtonTapped(_ sender: Any) {
        
        guard let email = userEmailTextField.text?.trimmingCharacters(in: .whitespaces) else {
            displayErrorMessage("Please enter an email address")
            return
        }
        guard let password = userPasswordTextField.text?.trimmingCharacters(in: .whitespaces) else {
            displayErrorMessage("Please enter a password")
            return
        }
        
        guard let raspberryPiName = raspberryPiNameTextField.text?.trimmingCharacters(in: .whitespaces) else {
            displayErrorMessage("Please enter a raspberry pi name")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                self.displayErrorMessage(error!.localizedDescription)
            } else {
                Auth.auth().signIn(withEmail: email, password: password) {(user, error) in
                    if error != nil {
                        self.displayErrorMessage(error!.localizedDescription)
                    } else {
                        var getPi = false
                        self.ref.observeSingleEvent(of: .value, with: { (snapshot) in
                           // let value = snapshot.key as? [String:Any]
                            for child in snapshot.children {
                                let key = (child as AnyObject).key as String
                                if key == raspberryPiName {
                                    getPi = true
                                }
                            }
                           // self.newUserData = value![raspberryPiName]
                            if getPi == true {
                                let userId = user?.user.uid
                                let homePage = self.storyboard?.instantiateViewController(withIdentifier: "BaseTabBarController") as! UITabBarController
                                let appDelegate = UIApplication.shared.delegate
                                appDelegate?.window??.rootViewController = homePage
                                let userRef = Database.database().reference().child("users/\(userId!)")
                                userRef.setValue("\(raspberryPiName)")
                            } else {
                                let user = Auth.auth().currentUser
                                user?.delete { error in
                                    if let error = error {
                                        // An error happened.
                                        print(error)
                                    } else {
                                        // Account deleted.
                                        self.displayErrorMessage("Please enter a valid Pi name!")
                                    }
                                }

                            }
                        })
                    }
                }
            }
        }
    }
    
    /*
     To display message given message data
     */
    func displayErrorMessage(_ errorMessage: String){
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController,animated: true, completion: nil)
    }
    
    /*
     To load the sign up page
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        cleanCoreData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
}

