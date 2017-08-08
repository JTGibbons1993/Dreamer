//
//  ItemCell.swift
//  Dreamer
//
//  Created by user on 8/8/17.
//  Copyright © 2017 John. All rights reserved.
//


import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    
    func configureCell(item: Item) {
           details.text = item.details
        
        
    }
    
}
