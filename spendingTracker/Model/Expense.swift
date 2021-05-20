//
//  Expense.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/3.
//

import UIKit

struct ExpenseData:Codable{
    
    var dateStr:String
    var amount:Int
    var category:Category
    var account:Account
    var receiptPhotoUrl:URL?
    var memo:String?
    
    struct Category: Codable {
        var incomeCategory:IncomeCategory?
        var expenseCategory:ExpenseCategory?
    }
    
    static var expenseCategories:[ExpenseCategory] {
        ExpenseCategory.allCases
    }
    static var incomeCategories:[IncomeCategory]{
        IncomeCategory.allCases
    }
    static var accounts:[Account]{
        Account.allCases
    }
    
    static let documentaryDirectoy = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask).first!
    
    
    static func saveExpenseData(expenseDatas:[ExpenseData]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(expenseDatas) else { return }
        let url = documentaryDirectoy.appendingPathComponent("expenseDatas")
        try? data.write(to: url)
    }
    
    static func loadExpenseDatas()->[Self]? {
        let url = documentaryDirectoy.appendingPathComponent("expenseDatas")
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([ExpenseData].self, from: data)
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
    
}


