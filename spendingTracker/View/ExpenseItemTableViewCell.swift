//
//  ExpenseTableViewCell.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/3.
//

import UIKit

class ExpenseItemTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
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
