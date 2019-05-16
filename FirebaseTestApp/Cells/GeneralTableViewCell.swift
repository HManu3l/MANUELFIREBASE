//
//  GeneralTableViewCell.swift
//  FirebaseTestApp
//
//  Created by developer on 5/9/19.
//  Copyright © 2019 napify. All rights reserved.
//

import UIKit

class GeneralTableViewCell: UITableViewCell {

    static let identifier = "GeneralTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var recyclingLabel: UILabel!
}
