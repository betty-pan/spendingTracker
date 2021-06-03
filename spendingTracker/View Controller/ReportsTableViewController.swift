//
//  ReportsTableViewController.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/14.
//

import UIKit
import CoreData
import Charts

class ReportsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    @IBOutlet weak var pieChartView: PieChartView!
    
    var container:NSPersistentContainer!
    var fetchResultController:NSFetchedResultsController<ExpenseData>!
    var allExpenseItems = [ExpenseData]()
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        setChartView()
        
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
        let popup = Popup()
        view.addSubview(popup)
        popup.topAnchor.constraint(equalTo:self.view.topAnchor).isActive = true
        popup.bottomAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        popup.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        popup.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    func fetchData() {
        allExpenseItems.removeAll()
        //Fetch data from CoreData
        let fetchRequest:NSFetchRequest<ExpenseData> = ExpenseData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateStr", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let context = container.viewContext
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            if let fetchObject = fetchResultController.fetchedObjects{
                allExpenseItems = fetchObject
            }
        } catch {
            print("讀取失敗的錯誤訊息：\(error)")
        }
    }
    
    func setChartView() {
        //生成項目數據 DataEntry
        let pieChartDataEntries = Expense.expenseCategories.map({(category)->PieChartDataEntry in
            return PieChartDataEntry(value: Double(calculateSum(category: category)), label: category.rawValue)
        })
        
        //設定項目 DataSet
        let dataSet = PieChartDataSet(entries: pieChartDataEntries, label: "我在這")
        // 設定項目顏色
        dataSet.colors = Expense.expenseCategories.map({ (category)->UIColor in
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
        return Expense.expenseCategories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ReportsTableViewCell.self)", for: indexPath)as?ReportsTableViewCell else { return UITableViewCell() }
        
        let category = Expense.expenseCategories[indexPath.row]
        cell.categoryImageView.image = UIImage(named: "\(category.rawValue)")
        cell.categoryLabel.text = category.rawValue
        cell.amountLabel.text = "$ \(numberFormatter(amount: calculateSum(category: category)))"
        
        return cell
        
    }
    func calculateSum(category:ExpenseCategory)->Int32 {
        let totalAmount = allExpenseItems.reduce(0,{if $1.category == category.rawValue{
                                                    return $0+Int($1.amount) };return $0})
        return Int32(totalAmount)
    }
    
    func dateFormatter(date:Date)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d, yyyy"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    func numberFormatter(amount:Int32)->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(from: NSNumber(value:amount))!
    }
}

class DigitValueFormatter: NSObject, ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        let valueWithoutDecimalPart = String(format: "%.1f%%", value)
        return valueWithoutDecimalPart
    }
}
