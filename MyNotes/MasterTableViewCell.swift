//
//  MasterTableViewCell.swift
//  MyNotes
//
//  Created by Seema on 6/20/15.
//  Copyright (c) 2015 CMA. All rights reserved.
//

import UIKit

class MasterTableViewCell: UITableViewCell {


    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var labelText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
