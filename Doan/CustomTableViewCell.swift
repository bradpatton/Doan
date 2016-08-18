//
//  CustomTableViewCell.swift
//  Doan
//
//  Created by Bradley Patton on 7/30/16.
//  Copyright © 2016 EtherLabs. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var backgroundLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() { super.awakeFromNib() }
    
    override func setSelected(selected: Bool, animated: Bool) { super.setSelected(selected, animated: animated) }

}
