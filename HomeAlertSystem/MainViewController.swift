//
//  MainViewController.swift
//  HomeAlertSystem
//
//  Created by Mappple on 23/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
    let aiv = UIActivityIndicatorView(style: .whiteLarge)
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let videoURL = URL(string: "http://172.20.10.9:8080/camera/livestream.m3u8")
//        let player = AVPlayer(url: videoURL!)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.present(playerViewController, animated: true) {
//            playerViewController.player!.play()
//    }
        

        
        setupPlayer()
        
    }
    
    func setupPlayer() {
        

        
        
        //let videoURL = URL(string: "http://172.20.10.9:8080/camera/livestream.m3u8")
        let videoURL = URL(string: "http://192.168.2.145:8080/camera/livestream.m3u8")
        let player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        let height = self.view.frame.width * 9 / 16
        let playerFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: height)
        playerLayer.frame = playerFrame
        
        let videoView = UIView(frame: playerFrame)
        
        videoView.backgroundColor = UIColor.black
        videoView.layer.addSublayer(playerLayer)
        
        self.view.addSubview(videoView)
        player.play()
        
        player.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        let controlsContainerView: UIView = {
            let view = UIView()
            //view.backgroundColor = UIColor(white: 1, alpha: 0.5)
            return view
        }()
        

        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        controlsContainerView.frame = playerFrame
        self.view.addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(aiv)
        aiv.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        aiv.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        
        
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            aiv.stopAnimating()
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
