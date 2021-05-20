//
//  ReportsTableViewCell.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/14.
//

import UIKit

class ReportsTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
