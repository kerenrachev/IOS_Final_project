//
//  TableViewCell.swift
//  Final_Project
//
//  Created by Hagai Kalinhoff on 06/07/2023.
//

import Foundation
import UIKit

class TableViewCellRec: UITableViewCell {

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBOutlet weak var recImage: UIImageView!
    
    
    @IBOutlet weak var recName: UILabel!
    
    @IBOutlet weak var prepTime: UILabel!
}
