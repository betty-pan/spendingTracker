//
//  AccountDetailTableViewCell.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/5.
//

import UIKit

class AccountDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
