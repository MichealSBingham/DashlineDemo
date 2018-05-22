//
//  HomeView.swift
//  Dashline
//
//  Created by David Slakter on 5/20/18.
//  Copyright © 2018 Dashline Inc. All rights reserved.
//

import Foundation
import UIKit



class HomeView: UIViewController, UITableViewDataSource{
    @IBOutlet var scanButton: UIButton!

    @IBOutlet weak var cartTableView: UITableView!
    var showDiscounts: Bool = true
    
    private var products: [Product] = []
    private var discounts: [String] = ["You have $20.10 in cash back 💸", "Milk is buy 1 get 1 free", "All fruits are on a 20% discount", "Buy soap, get 1 50% off", "All meats have a 30% markdown today", "Spend $100 get cashback bonus!"]
    
    @IBOutlet weak var showPromotionsLabel: UILabel!
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        
        if showDiscounts{
            showPromotionsLabel.text = "Show Shopping Cart"
        } else{
            showPromotionsLabel.text = "Show Promotions"
        }
        
        cartTableView.dataSource = self
        cartTableView.separatorStyle = .none
        cartTableView.allowsSelection = false
        
       Product.generateRandomProducts()
    
        NotificationCenter.default.addObserver(self, selector: #selector(HomeView.addProductToList(_:)), name: .productAdded, object: nil)
    }
    @IBAction func showScanner(_ sender: Any) {
        NotificationCenter.default.post(Notification(name: .showScanner))
         NotificationCenter.default.post(Notification(name: .didShowScanner))
    }
    @IBAction func showCheckout(_ sender: Any) {
        performSegue(withIdentifier: "showCheckout", sender: nil)
    }
    
    // Reload TableView
    @objc func addProductToList(_ notification: NSNotification)  {
        let new_product = notification.userInfo!["product"] as! Product
        
        var duplicate_exists = false
        
        for product in products{
            
            if product.id == new_product.id{
                // The products are the same so replace it
                
                products[products.index(of: product)!] = new_product
                
                duplicate_exists = true
                cartTableView.reloadData()
                
            }
        }
        
        guard !duplicate_exists else{
            
            return
        }
        
        products.append(new_product)
        cartTableView.reloadData()
        
        
    }
    
    
    
    @IBAction func didTapTogglePromotions(_ sender: Any) {
        
        showDiscounts = !showDiscounts
        showPromotionsLabel.text = showDiscounts ? "Show Shopping Cart" : "Show Promotions"
        
        cartTableView.reloadData()
    }
    
    
    
    // Table View Functions
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if showDiscounts {
            return discounts.count
        }
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if showDiscounts{
            
             let cell = cartTableView.dequeueReusableCell(withIdentifier: "discountCell")
            cell?.textLabel?.text = discounts[indexPath.row]
            
            return cell!
        }
        
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "productCellID") as! ProductTableViewCell
        let product = products[indexPath.row]
        
        // Ensures that the correct total product price is calculated
        product.calculateTotal()
        
        cell.productCellName.text = product.name
        cell.productCellQuantity.text = "\(product.quantity)"
        cell.productCellPrice.text = "$\(product.price)"
        
        return cell
    }
}
