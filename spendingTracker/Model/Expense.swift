//
//  Expense.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/3.
//

import UIKit

struct Expense{
    static var expenseCategories:[ExpenseCategory] {
        ExpenseCategory.allCases
    }
    static var incomeCategories:[IncomeCategory]{
        IncomeCategory.allCases
    }
    static var accounts:[Account]{
        Account.allCases
    }
    static func fetchReceiptImage(imageUrl:URL?, imageView:UIImageView) {
        if let url = imageUrl{
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data{
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }else{
            print("沒有照片")
        }
    }
    
    //資料存於資料夾
//    static let documentaryDirectoy = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask).first!
//    
//    static func saveExpenseData(expenseDatas:[ExpenseData1]) {
//        let encoder = JSONEncoder()
//        guard let data = try? encoder.encode(expenseDatas) else { return }
//        let url = documentaryDirectoy.appendingPathComponent("expenseDatas")
//        try? data.write(to: url)
//    }
//    
//    static func loadExpenseDatas()->[Self]? {
//        let url = documentaryDirectoy.appendingPathComponent("expenseDatas")
//        guard let data = try? Data(contentsOf: url) else { return nil }
//        let decoder = JSONDecoder()
//        return try? decoder.decode([ExpenseData1].self, from: data)
//    }
}


