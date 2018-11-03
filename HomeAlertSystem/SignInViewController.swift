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
    
    
    /*
     To sign in the user to the home page when sign in button is tapped
     */
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
    
    
    /*
     To go to sign up page when sign up button is tapped
     */
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(signUpViewController,animated: true)
        
    }
    
    /*
     To load the sign in page
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension UIViewController {
    func setBackgroundImage(_ imageName: String, contentMode: UIView.ContentMode) {
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: imageName)
        backgroundImage.contentMode = contentMode
        self.view.insertSubview(backgroundImage, at: 0)
    }
}
