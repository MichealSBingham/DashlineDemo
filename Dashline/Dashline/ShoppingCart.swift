//
//  ShoppingCart.swift
//  Dashline
//
//  Created by Micheal S. Bingham on 5/20/18.
//  Copyright © 2018 Dashline Inc. All rights reserved.
//

import Foundation


class ShoppingCart{
    
    /// Returns the total tax of all items in the cart
    class func getCartTaxTotal() -> Double{
        var total = 0.0
        let allProducts = uiRealm.objects(Product.self)
        for product in allProducts{
            total += product.total_tax
        }
        
        return total
    }
    
    /// Returns the total  of all items in the cart; including tax and discounts
    class func getCartTotal() -> Double{
        var total = 0.0
        let allProducts = uiRealm.objects(Product.self)
        for product in allProducts{
            product.calculateTotal()
            total += product.total
        }
        
        return total
    }
}
