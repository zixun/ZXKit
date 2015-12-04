//
//  ViewController.swift
//  ZXKit
//
//  Created by chenyilongyellow on 12/02/2015.
//  Copyright (c) 2015 chenyilongyellow. All rights reserved.
//

import UIKit
import ZXKit
import Neon

class ViewController: UIViewController {

    private lazy var test: ZXFileDirectoryView = {
        let new = ZXFileDirectoryView()
        new.basePath = "/Users/user/Documents/code/play/ZXKit"
        return new
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.test)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.test.anchorAndFillEdge(Edge.Left, xPad: 0, yPad: 0, otherSize: 300)
    }

}

