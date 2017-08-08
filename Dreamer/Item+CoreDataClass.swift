//
//  Item+CoreDataClass.swift
//  Dreamer
//
//  Created by user on 8/8/17.
//  Copyright © 2017 John. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    //inserts in NSManaged Object context
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.created = NSDate()
        
    }
}
