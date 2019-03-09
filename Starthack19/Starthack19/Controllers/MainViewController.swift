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
