//
//  ContainerView.swift
//  Dashline
//
//  Created by David Slakter on 5/19/18.
//  Copyright © 2018 Dashline Inc. All rights reserved.
//

import Foundation
import UIKit


class ContainerView: UIViewController {

    var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "home")
        let scannerVC = storyboard?.instantiateViewController(withIdentifier: "scanner")
        let storeVC = storyboard?.instantiateViewController(withIdentifier: "chooseStore")
        
        self.addChildViewController(homeVC!)
        self.addChildViewController(scannerVC!)
        self.addChildViewController(storeVC!)
        scrollView = UIScrollView(frame: view.bounds)
        let scrollWidth = view.frame.width
        let scrollHeight = 3*view.frame.height
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        
        scrollView.addSubview(homeVC!.view)
        scrollView.addSubview(scannerVC!.view)
        scrollView.addSubview(storeVC!.view)
        
        
    }


}
