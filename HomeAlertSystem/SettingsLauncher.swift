//
//  SettingLauncher.swift
//  HomeAlertSystem
//
//  Created by Ming Yang on 1/11/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class Setting: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}


class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: settingCellId)
    }
    
   
    
    let blackView = UIView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.black
        return cv
    }()
    let settingCellId = "settingCell"
    let settings: [Setting] = {
       return [Setting(name: "About Page", imageName: "details"), Setting(name: "Sign Out", imageName: "details")]
    }()
    var mainViewController: MainViewController?
    
    
    
    @objc func showSettings(sender: UIBarButtonItem){
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss(sender:))))
            
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            //This is the height of collectionView
            let height: CGFloat = 90
            //let y = 90 + height
            
            
            
            collectionView.frame = CGRect(x: 0 as CGFloat, y: 90, width: 120, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 90, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
                
            }, completion: nil)
            
        }
        
        
        
    }
    
    @objc func handleDismiss(sender: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: -90, width: self.collectionView.frame.width, height: 0)
            }
            
        })
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: settingCellId, for: indexPath) as! SettingCell
        let setting = settings[indexPath.item]
        cell.setting = setting
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
        
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! SettingCell
        if settings[indexPath.item].name == "About Page" {

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 0
                
                if let window = UIApplication.shared.keyWindow {
                    self.collectionView.frame = CGRect(x: 0, y: -90, width: self.collectionView.frame.width, height: 0)
                }
            }) {(completed: Bool) in
                
                self.mainViewController?.showControllerForSettingsLauncher()
                
            }
            
        }
        if settings[indexPath.item].name == "Sign Out" {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 0
                
                if let window = UIApplication.shared.keyWindow {
                    self.collectionView.frame = CGRect(x: 0, y: -90, width: self.collectionView.frame.width, height: 0)
                }
            }) {(completed: Bool) in
                
                self.mainViewController?.signOutForSettingLauncher()
                
            }
            
//            do {
//                try Auth.auth().signOut()
//            } catch{
//
//            }
//
//            let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
//            let appDelegate = UIApplication.shared.delegate
//            appDelegate?.window??.rootViewController = signInPage
            
        }
    }
    
    
    
    
    
    
    
}
