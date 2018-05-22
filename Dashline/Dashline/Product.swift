//
//  Product.swift
//  Dashline
//
//  Created by Micheal S. Bingham on 5/18/18.
//  Copyright © 2018 Dashline Inc. All rights reserved.
//


import Foundation
import RealmSwift



class Product: Object{
    
    @objc dynamic var id = "0"
    @objc dynamic var name = ""
    @objc dynamic var price: Double = 0.0
    @objc dynamic var quantity: Int = 0
    @objc dynamic var tax_rate: Double = 0.0
    @objc dynamic var total: Double = 0.0
    @objc dynamic var total_tax: Double = 0.0
    
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /// Obtains a Product Object by its ID - the barcode string. Returns a nil object if the object cannot be found. Checks if the object was added in shopping cart first, if not, pulls from database.
    class func get(withID: String, then: (Product?) -> Void){
        
        
        
        if let item = uiRealm.object(ofType: Product.self, forPrimaryKey: withID){
            // Item has been added to the shopping cart
            
            then(item)
            
        } else {
            
            // ******* Get From Database *******
            then(nil)
            // ******* Get From Database *******
        }
    }
    
   
    
    /// Adds a Product Object to the shopping cart. This function will update values of the 'Product'. Before modifying attributes of a Product object, call .beginWrite() and then call .commitWrite() afterwards. Example : try! uiRealm.beginWrite(); product!.quantity = quantity+1;  try! uiRealm.commitWrite()
    func addToCart()  {
        
        
        
        try! uiRealm.write {
            
            uiRealm.add(self, update: true)
            
        }
        
        
        
    }
    
    
    /// Calculates the total price of a particular product in the shopping cart based on its quantity, tax, and price. This function should be called whenever a product item is added or updated in the database.
    func calculateTotal() {
        print("Calculate Total")
        var price = self.price * Double(self.quantity)
        print("the price is: \(price)")
        var tax = (tax_rate/100) * price
        try! realm?.beginWrite()
        self.total_tax = tax
        self.total = price+tax
        try! realm?.commitWrite()
        self.addToCart()
        
        
    }
    
    
    
   class func generateRandomProducts()  {
   
        try! uiRealm.write {
            uiRealm.deleteAll()
        }
        
        try! uiRealm.beginWrite()
        
        let apple = Product()
        apple.name = "Apple"
        apple.id  = "1"
        apple.price = 1.23
        apple.tax_rate = 0
        
        let bread = Product()
        bread.name = "Bread"
        bread.id  = "2"
        bread.price = 1.99
        bread.tax_rate = 0
        
        let milk = Product()
        milk.name = "Milk"
        milk.id  = "3"
        milk.price = 2.82
        milk.tax_rate = 0
        
        let candybar = Product()
        candybar.name = "Candy Bar"
        candybar.id  = "4"
        candybar.price = 0.99
        candybar.tax_rate = 0
        
        try! uiRealm.commitWrite()
        
        apple.addToCart()
        bread.addToCart()
        milk.addToCart()
        candybar.addToCart()
        
    
        
    }
    
    
    // Call this whenever the quantity of a product is changed. Posts a notification that the quantity of a product has changed and passes the product as data in the notification under userInfo["product"].
    func notifyQuantityChange()  {
        NotificationCenter.default.post(name: .productQuantityDidChange, object: self, userInfo: ["product" : self])
    }
    
    // Call this whenever a product is removed. Passes the product as data in the notification under userInfo["product"].
    func notifyProductRemoved()  {
        NotificationCenter.default.post(name: .productRemoved, object: self, userInfo: ["product": self])
        
    }
    
    // Call this whenever a product is added. Passes the product as data in the notification under userInfo["product"].
    func notifyProductAdded()  {
        NotificationCenter.default.post(name: .productAdded, object: self, userInfo: ["product": self])
        
    }
    
}

extension Notification.Name {
    
    static let productQuantityDidChange = Notification.Name("productQuantityDidChange")
    static let productRemoved = Notification.Name("productRemoved")
    static let productAdded = Notification.Name("productAdded")
}

