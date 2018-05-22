//
//  HomeView.swift
//  Dashline
//
//  Created by David Slakter on 5/20/18.
//  Copyright © 2018 Dashline Inc. All rights reserved.
//

import Foundation
import UIKit



class HomeView: UIViewController{
    @IBOutlet var scanButton: UIButton!
    @IBOutlet var itemsList: UITextView!
    
   override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
       Product.generateRandomProducts()
    }
    @IBAction func showScanner(_ sender: Any) {
        NotificationCenter.default.post(Notification(name: .showScanner))
         NotificationCenter.default.post(Notification(name: .didShowScanner))
    }
    @IBAction func showCheckout(_ sender: Any) {
        performSegue(withIdentifier: "showCheckout", sender: nil)
    }
    
}
