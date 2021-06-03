//
//  CategoryCollectionViewController.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/5.
//

import UIKit

private let reuseIdentifier = "\(CategoryDetailCollectionViewCell.self)"

class CategoryCollectionViewController: UICollectionViewController {
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var row:Int?
    var isExpenseCategory:Bool?
    
    init?(coder:NSCoder, isExpenseCategory:Bool) {
        self.isExpenseCategory = isExpenseCategory
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        collectionView.reloadData()
       
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        row = collectionView.indexPathsForSelectedItems?.first?.row
        
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isExpenseCategory == true {
            return Expense.expenseCategories.count
        }else{
            return Expense.incomeCategories.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryDetailCollectionViewCell else { return UICollectionViewCell() }
        if isExpenseCategory == true {
            let expenseCategory = Expense.expenseCategories[indexPath.row]
            cell.categoryLabel.text = expenseCategory.rawValue
            cell.categoryImageView.image = UIImage(named: "\(expenseCategory.rawValue)")
        }else{
            let incomeCategory = Expense.incomeCategories[indexPath.row]
            cell.categoryLabel.text = incomeCategory.rawValue
            cell.categoryImageView.image = UIImage(named: "\(incomeCategory.rawValue)")
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
