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

        gifuView.animateWithImage(named: "xLHyPA_fast.gif")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
