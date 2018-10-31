//
//  SignInViewController.swift
//  HomeAlertSystem
//
//  Created by Ming Yang on 23/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import Firebase


class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        guard let email = userEmailTextField.text else {
            displayErrorMessage("Please enter an email address")
            return
        }
        guard let password = userPasswordTextField.text else {
            displayErrorMessage("Please enter a password")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {(user, error) in
            //print ("The sign in user id:")
            //print (user?.user.uid)
            if error != nil {
                self.displayErrorMessage(error!.localizedDescription)
            } else {
                
                let homePage = self.storyboard?.instantiateViewController(withIdentifier: "BaseTabBarController") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = homePage
                
                
            }
            
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(signUpViewController,animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayErrorMessage(_ errorMessage: String){
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController,animated: true, completion: nil)
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

