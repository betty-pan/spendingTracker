//
//  CategoryDetailCollectionViewCell.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/5.
//

import UIKit

class CategoryDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var cellWidthConstraint: NSLayoutConstraint!
    let width = floor((UIScreen.main.bounds.width-20*2-40)/3)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellWidthConstraint.constant = self.width
    }
}
