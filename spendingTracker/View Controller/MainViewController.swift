//
//  MainViewController.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/3.
//

import UIKit
import CoreData

class MainViewController: UIViewController, NSFetchedResultsControllerDelegate{
    var container:NSPersistentContainer!
    var fetchResultController:NSFetchedResultsController<ExpenseData>!
    var expenseItems = [ExpenseData](){
        didSet{
            if expenseItems.isEmpty{
                noItemlabel.isHidden = false
            }else{
                noItemlabel.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var noItemlabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(dateStr: dateFormatter(date: Date()))
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNavigationController" {
            if let navigationController = segue.destination as? UINavigationController,
               let targetController = navigationController.topViewController as? AddExpenseItemTableViewController,
               let row = tableView.indexPathForSelectedRow?.row{
                targetController.expenseData = expenseItems[row]
                print("給資料")
            }
        }else{
            if let navigationController = segue.destination as? UINavigationController,
               let targetController = navigationController.topViewController as? AddExpenseItemTableViewController{
                targetController.selectedDate = dateFormatter(date: datePicker.date)
                print("給date \(dateFormatter(date: datePicker.date))")
            }
        }
    }
    
    @IBAction func unwindToMainScene(_ unwindSegue: UIStoryboardSegue) {
        if let controller = unwindSegue.source as? AddExpenseItemTableViewController,
           let expenseItem = controller.expenseData{
            let context = container.viewContext
            
            if tableView.indexPathForSelectedRow != nil{
                print("修改資料")
            }else{
                context.insert(expenseItem)
                print("新增資料")
            }
            container.saveContext()
            tableView.reloadData()
        }
    }
    @IBAction func changeDate(_ sender: UIDatePicker) {
        fetchData(dateStr: dateFormatter(date: datePicker.date))
        tableView.reloadData()
    }
    
    func updateUI(){
        noItemlabel.text = "  No data to display.\n  Please click [+] to add new record."
        datePicker.tintColor = UIColor(named: "MainColor")
        tableView.backgroundColor = UIColor.systemGray5
        
    }
    func fetchData(dateStr:String) {
        expenseItems.removeAll()
        //Fetch data from CoreData
        let fetchRequest:NSFetchRequest<ExpenseData> = ExpenseData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateStr", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "dateStr == %@", dateFormatter(date: datePicker.date))
        
        let context = container.viewContext
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            if let fetchObject = fetchResultController.fetchedObjects{
                expenseItems = fetchObject
            }
        } catch {
            print("讀取失敗的錯誤訊息：\(error)")
        }
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
        let amountStr = formatter.string(from: NSNumber(value:amount))!
        return amountStr
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
    
    // 準備開始處理內容更變時會被呼叫
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath{
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                print("### FetchController 新增")
            }
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .automatic)
                print("### FetchController 刪除")
            }
        default:
            tableView.reloadData()
        }
        if let fetchObjects = controller.fetchedObjects{
            expenseItems = fetchObjects as! [ExpenseData]
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension MainViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let expAmount = expenseItems.reduce(0, {if $1.isExpense==true {return $0+Int($1.amount)};return $0})
        let incAmount = expenseItems.reduce(0, {if $1.isExpense==false {return $0+Int($1.amount) };return $0})
        if expenseItems.isEmpty{
            return nil
        }else{
            return "EXP: \(expAmount)   INC: \(incAmount)   TOTAL: \(expAmount - incAmount)"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ExpenseItemTableViewCell.self)", for: indexPath) as? ExpenseItemTableViewCell else { return UITableViewCell() }
        let expenseItem = expenseItems[indexPath.row]
        cell.amountLabel.text = numberFormatter(amount: expenseItem.amount)
        cell.accountLabel.text = expenseItem.account
        cell.memoLabel.text = expenseItem.memo
        
        if expenseItem.isExpense == true {
            cell.categoryLabel.text = expenseItem.category
            cell.categoryImageView.image = UIImage(named: "\(expenseItem.category!)")
            cell.amountLabel.backgroundColor = UIColor.clear
            cell.amountLabel.textColor = UIColor.black
        }else{
            cell.categoryLabel.text = expenseItem.category
            cell.categoryImageView.image = UIImage(named: expenseItem.category ?? "")
            cell.amountLabel.backgroundColor = UIColor.systemGreen
            cell.amountLabel.textColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        container.viewContext.delete(self.fetchResultController.object(at: indexPath))
        container.saveContext()

    }
}

