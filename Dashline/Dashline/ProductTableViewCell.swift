//
//  ProductTableViewCell.swift
//  Dashline
//
//  Created by Dr. Stephen, Ph.D on 5/22/18.
//  Copyright © 2018 Dashline Inc. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productCellName: UILabel!
    
    @IBOutlet weak var productCellQuantity: UILabel!
    
    @IBOutlet weak var productCellPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


