//
//  ViewController.swift
//  ZXKit
//
//  Created by user on 15/11/12.
//  Copyright © 2015年 陈奕龙. All rights reserved.
//

import UIKit
import Neon

class ViewController: UIViewController {

    private lazy var test :ZXFileDirectoryView = {
        let new = ZXFileDirectoryView()
        return new
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        self.view.addSubview(self.test)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.test.anchorAndFillEdge(Edge.Left, xPad: 0, yPad: 0, otherSize: 250)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

