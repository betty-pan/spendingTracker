//
//  ReceiptPhotoViewController.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/5.
//

import UIKit

class ReceiptPhotoViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var receiptImageData:Data?
    
    init?(coder:NSCoder, receiptImageData:Data?) {
        self.receiptImageData = receiptImageData
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(data: receiptImageData!)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        receiptImageData = nil
    }
}
