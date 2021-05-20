//
//  ReceiptPhotoViewController.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/5.
//

import UIKit

class ReceiptPhotoViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var receiptImageUrl:URL?
    
    init?(coder:NSCoder, receiptImageUrl:URL?) {
        self.receiptImageUrl = receiptImageUrl
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExpenseData.fetchReceiptImage(imageUrl: receiptImageUrl, imageView: imageView)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        receiptImageUrl = nil
    }
}
