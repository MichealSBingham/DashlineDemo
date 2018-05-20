//
//  CheckoutView.swift
//  Dashline
//
//  Created by David Slakter on 5/20/18.
//  Copyright © 2018 Dashline Inc. All rights reserved.
//

import Foundation
import UIKit

class CheckoutView: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
}
