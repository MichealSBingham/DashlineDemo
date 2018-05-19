//
//  ShoppingCart.swift
//  Dashline
//
//  Created by Micheal S. Bingham  on 5/18/18.
//  Copyright © 2018 Dashline Inc. All rights reserved.
//

import Foundation
import RealmSwift

class ShoppingCart: Object{
    
    let products = List<Product>()
    
}
