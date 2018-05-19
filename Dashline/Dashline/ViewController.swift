//
//  ViewController.swift
//  Dashline
//
//  Created by Micheal S. Bingham on 5/18/18.
//  Copyright © 2018 Dashline Inc. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      // Observers
        NotificationCenter.default.addObserver(forName: .productAdded, object: nil, queue: nil) { (notification) in
            
            let product = notification.userInfo!["product"] as! Product
            product.calculateTotal()
            
            switch product.name{
            case "Apple":
                self.appleQuantity.text = "\(product.quantity)"
                 self.applesTotal.text = "\(product.total)"
                break
            case "Drink":
                  self.drinkQuantity.text = "\(product.quantity)"
                   self.drinkTotal.text = "\(product.total)"
                break
            case "Gum":
                  self.gumQuantity.text = "\(product.quantity)"
                   self.gumTotal.text = "\(product.total)"
                break
            default:
                break
            }
            
            self.cartTotal.text = "\(Product.getCartTotal())"
            self.taxTotal.text = "\(Product.getCartTaxTotal())"
          
            
        }
        
        
        
        
        
        
    }
    
    @IBOutlet weak var gumQuantity: UITextField!
    
    @IBOutlet weak var appleQuantity: UITextField!
    
    @IBOutlet weak var drinkQuantity: UITextField!
    
    @IBOutlet weak var gumTotal: UITextField!
    
    @IBOutlet weak var applesTotal: UITextField!
    
    @IBOutlet weak var drinkTotal: UITextField!
    
    @IBOutlet weak var taxTotal: UITextField!
    
    @IBOutlet weak var cartTotal: UITextField!
    
    
    @IBAction func didTapAddGum(_ sender: Any) {
        
        Product.get(withID: "500") { (gum) in
            
            let quantity = gum!.quantity
            gumQuantity.text = "\(quantity + 1 )"
            
            try! uiRealm.beginWrite()
            gum!.quantity = quantity+1
            try! uiRealm.commitWrite()
            gum!.addToCart()
            gum!.notifyProductAdded()
        }
        
        
        
        
        
    }
    
    @IBAction func didTapAddApples(_ sender: Any) {
        
        Product.get(withID: "1") { (apple) in
            
            let quantity = apple!.quantity
            appleQuantity.text = "\(quantity + 1 )"
            
            try! uiRealm.beginWrite()
            apple!.quantity = quantity+1
            try! uiRealm.commitWrite()
            apple!.addToCart()
             apple!.notifyProductAdded()
        }
        
    }
    
    @IBAction func didTapAddDrink(_ sender: Any) {
        
        Product.get(withID: "222") { (drink) in
            
            let quantity = drink!.quantity
            drinkQuantity.text = "\(quantity + 1 )"
            
            try! uiRealm.beginWrite()
            drink!.quantity = quantity+1
            try! uiRealm.commitWrite()
            drink!.addToCart()
             drink!.notifyProductAdded()
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func didTapAddProductsToDatabase(_ sender: Any) {
        
        let apple = Product()
        apple.id = "1"
        apple.name = "Apple"
        apple.price = 1.50
        apple.tax_rate = 4.5
        
        let drink = Product()
        drink.id = "222"
        drink.name = "Drink"
        drink.price = 2.50
        drink.tax_rate = 6
        
        
        let gum = Product()
        gum.id = "500"
        gum.name = "Gum"
        gum.price = 99
        gum.tax_rate = 0
        
        
        
        try! uiRealm.write{
            uiRealm.add(apple, update: true)
            uiRealm.add(gum, update: true)
            uiRealm.add(drink, update: true)
        }
        
    }
}

