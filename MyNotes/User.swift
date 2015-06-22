//
//  User.swift
//  MyNotes
//
//  Created by Seema on 6/21/15.
//  Copyright (c) 2015 CMA. All rights reserved.
//

import UIKit

class User: PFUser, PFSubclassing {
    
    @NSManaged var user: User
    
    override class func load() {
        self.registerSubclass()
    }
}
