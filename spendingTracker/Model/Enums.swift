//
//  Enums.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/3.
//

import Foundation

enum DataCategorys:String, CaseIterable {
    case neededDatas, additionalDatas
}
enum NeededDatas:String, CaseIterable {
    case date, amount, category, account
}
enum AdditionalDatas:String, CaseIterable {
    case receiptPhoto, memo
}

enum ExpenseCategory: String, CaseIterable, Codable {
    case food = "飲食"
    case clothes = "服飾"
    case house = "居家"
    case transportation = "交通"
    case education = "教育"
    case entertainment = "娛樂"
}
enum IncomeCategory: String, CaseIterable, Codable {
    case salary = "薪水"
    case bonus = "獎金"
    case investment = "投資"
}
enum Account:String, CaseIterable, Codable {
    case cash = "現金"
    case bank = "銀行"
    case creditCard = "信用卡"
}
