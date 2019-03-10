//
//  ASLSpellingVC.swift
//  Starthack19
//
//  Created by Lionel Pellier on 09/03/2019.
//  Copyright © 2019 Lionel Pellier. All rights reserved.
//

import UIKit

class ASLSpellingVC: UIViewController {
    
    var text: String = ""
    var images = [UIImage]()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for letter in text{
            images.append(UIImage(imageLiteralResourceName: ASLAlphabet.ASLAlphabet[String(letter)]!))
        }
        
        spell()
    }


    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func spell(){
        text = text.lowercased()
        self.imageView.animationImages = images
        self.imageView.animationDuration = Double(images.count) / 1.25
        self.imageView.startAnimating()
    }
    
    @IBAction func replay(_ sender: Any) {
        spell()
    }
}
