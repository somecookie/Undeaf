//
//  MainViewController.swift
//  Starthack19
//
//  Created by Lionel Pellier on 09/03/2019.
//  Copyright © 2019 Lionel Pellier. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var audioView: UIView!
    @IBOutlet weak var videoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        let tapAudio = UITapGestureRecognizer(target: self, action: #selector(goToAudio))
        let tapVideo = UITapGestureRecognizer(target: self, action: #selector(goToVideo))
        
        audioView.addGestureRecognizer(tapAudio)
        videoView.addGestureRecognizer(tapVideo)
        
        audioView.backgroundColor = UIColor(hexString: "004B68")
        audioView.clipsToBounds = false
        audioView.layer.cornerRadius = 10.0
        audioView.layer.shadowColor = UIColor(hexString: "004B68").cgColor
        audioView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        audioView.layer.shadowRadius = 4.0
        audioView.layer.shadowOpacity = 0.8
        
        videoView.backgroundColor = UIColor(hexString: "004B68")
        videoView.clipsToBounds = false
        videoView.layer.cornerRadius = 10.0
        videoView.layer.shadowColor = UIColor(hexString: "004B68").cgColor
        videoView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        videoView.layer.shadowRadius = 4.0
        videoView.layer.shadowOpacity = 0.8
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func goToAudio(){
        performSegue(withIdentifier: "audio", sender: self)
    }
    
    @objc func goToVideo(){
        performSegue(withIdentifier: "video", sender: self)
    }
}
