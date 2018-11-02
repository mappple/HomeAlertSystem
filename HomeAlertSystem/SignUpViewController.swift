//
//  SignUpViewController.swift
//  HomeAlertSystem
//
//  Created by Ming Yang on 24/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    
    
    
    
    
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    @IBOutlet weak var raspberryPiNameTextField: UITextField!
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func signUpConfirmButtonTapped(_ sender: Any) {
        
        guard let email = userEmailTextField.text else {
            displayErrorMessage("Please enter an email address")
            return
        }
        guard let password = userPasswordTextField.text else {
            displayErrorMessage("Please enter a password")
            return
        }
        
        guard let raspberryPiName = raspberryPiNameTextField.text else {
            displayErrorMessage("Please enter a raspberry pi name")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                self.displayErrorMessage(error!.localizedDescription)
            } else {
                
                Auth.auth().signIn(withEmail: email, password: password) {(user, error) in
                    print ("")
                    if error != nil {
                        self.displayErrorMessage(error!.localizedDescription)
                    } else {
                        
                        if let userId = user?.user.uid {
                            
                            let homePage = self.storyboard?.instantiateViewController(withIdentifier: "BaseTabBarController") as! UITabBarController
                            let appDelegate = UIApplication.shared.delegate
                            appDelegate?.window??.rootViewController = homePage
                            
                            let userRef = Database.database().reference().child("users/\(userId)")
                            userRef.setValue("\(raspberryPiName)")
                            
                        } else {
                            
                            print ("error in creating a new reference for a new user")
                        }
                        
                        
                    }
                }

            }
        }
        
        
    }
    
    func displayErrorMessage(_ errorMessage: String){
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController,animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

