//
//  MemeDetailViewController.swift
//  Meme Me
//
//  Created by Victor Guthrie on 10/10/15.
//  Copyright © 2015 Victor Guthrie. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var memeImage: UIImageView!
    
    var meme: Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let meme = meme {
            memeImage.image = meme.combinedImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
