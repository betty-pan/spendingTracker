//
//  ReportsTableViewController.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/14.
//

import UIKit
import Charts

class ReportsTableViewController: UITableViewController{
    @IBOutlet weak var pieChartView: PieChartView!
    
    var allExpenseItems = [ExpenseData]()
    
    var pieChartDataEntries = [PieChartDataEntry]()
    
    override func viewWillAppear(_ animated: Bool) {
        if let allItems = ExpenseData.loadExpenseDatas(){
            self.allExpenseItems = allItems
            setChartView()
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //legend
        let legend = pieChartView.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        //將資料設百分比顯示
        pieChartView.usePercentValuesEnabled = true
        
    }
    
    @IBAction func selectMonth(_ sender: Any) {
        
    }
    
    
    func setChartView() {
        //生成項目數據 DataEntry
        pieChartDataEntries = ExpenseData.expenseCategories.map({(category)->PieChartDataEntry in
            return PieChartDataEntry(value: Double(calculateSum(category: category)), label: category.rawValue)
        })
        
        //設定項目 DataSet
        let dataSet = PieChartDataSet(entries: pieChartDataEntries, label: "")
        // 設定項目顏色
        dataSet.colors = ExpenseData.expenseCategories.map({ (category)->UIColor in
            return UIColor(named: "\(category)") ?? UIColor.white
        })
        // 點選後突出距離
        dataSet.selectionShift = 10
        // 圓餅分隔間距
        dataSet.sliceSpace = 5
        // 不顯示數值
        //         dataSet.drawValuesEnabled = false
        
        //設定資料 Data
        let data = PieChartData(dataSet: dataSet)
        data.setValueFormatter(DigitValueFormatter())
        pieChartView.data = data
        
        let totalAmount = allExpenseItems.reduce(0, {$0+$1.amount})
        pieChartView.centerText = "支出總和\n$\(numberFormatter(amount: totalAmount))"
        
        //動畫
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Categories"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ExpenseData.expenseCategories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ReportsTableViewCell.self)", for: indexPath)as?ReportsTableViewCell else { return UITableViewCell() }
        
        let category = ExpenseData.expenseCategories[indexPath.row]
        cell.categoryImageView.image = UIImage(named: "\(category)")
        cell.categoryLabel.text = category.rawValue
        cell.amountLabel.text = "$ \(numberFormatter(amount: calculateSum(category: category)))"
        
        
        return cell
        
    }
    func calculateSum(category:ExpenseCategory)->Int {
        let totalAmount = allExpenseItems.reduce(0,{if $1.category.expenseCategory == category{
            return $0+$1.amount };return $0})
        
        return totalAmount
    }
    
    func dateFormatter(date:Date)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d, yyyy"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    func numberFormatter(amount:Int)->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let amountStr = formatter.string(from: NSNumber(value:amount))!
        return amountStr
    }
    
}

class DigitValueFormatter: NSObject, ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        let valueWithoutDecimalPart = String(format: "%.1f%%", value)
        return valueWithoutDecimalPart

    }
}
