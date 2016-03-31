//
//  ViewController.swift
//  gifu-test
//
//  Created by Matt Seiler on 3/30/16.
//  Copyright © 2016 Fitnet. All rights reserved.
//

import UIKit
import Gifu

class ViewController: UIViewController {

    @IBOutlet weak var gifuView: AnimatableImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let url = NSURL(string: "https://media.giphy.com/media/VvHuInLUolJde/giphy.gif"),
            data = NSData(contentsOfURL: url) {
            gifuView.animateWithImageData(data)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

