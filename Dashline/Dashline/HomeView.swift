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
    
    private var products: [Product] = []
    
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
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
    
    
    
    // Table View Functions
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
