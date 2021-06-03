//
//  AddExpenseItemTableViewController.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/12.
//

import UIKit
import CoreData

class AddExpenseItemTableViewController: UITableViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var receiptPhotoImageView: UIImageView!
    @IBOutlet weak var memoTextField: UITextField!
    
    var expenseData:ExpenseData?
    var selectedDate:String?

    var isExpenseCategory:Bool?
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let expenseData = expenseData{
            self.expenseData = expenseData
        }
        updateUI()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if amountTextField.text?.isEmpty == true{
            didNotCompleteAlertController()
            return false
        }else{
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataCategory = DataCategorys.allCases[indexPath.section]
        switch dataCategory {
        case .neededDatas:
            let neededData = NeededDatas.allCases[indexPath.row]
            switch neededData {
            case .date:
                return
            case .amount:
                return
            case .category:
                performSegue(withIdentifier: "\(CategoryCollectionViewController.self)", sender: nil)
            case .account:
                performSegue(withIdentifier: "\(AccountTableViewController.self)", sender: nil)
            }
        case .additionalDatas:
            let additionalData = AdditionalDatas.allCases[indexPath.row]
            switch additionalData {
            case .receiptPhoto:
                if receiptPhotoImageView.image == nil{
                    selectPhotoAlertController()
                }else{
                    showReceiptImageController()
                }
            case .memo:
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.destination as? MainViewController,
           let appDelegate:AppDelegate = UIApplication.shared.delegate as? AppDelegate{
            if expenseData == nil{
                let expenseItem = ExpenseData(context: appDelegate.persistentContainer.viewContext)
                
                expenseItem.account = accountLabel.text
                expenseItem.amount = Int32(amountTextField.text!) ?? 0
                expenseItem.category = categoryLabel.text
                expenseItem.dateStr = dateTextField.text
                expenseItem.isExpense = isExpenseCategory ?? true
                
                if let memo = memoTextField.text{
                    expenseItem.memo = memo
                }
                if let photo = receiptPhotoImageView.image{
                    expenseItem.receiptPhoto = photo.pngData()
                }
                expenseData = expenseItem
                print("### 新增，回去")
            }else{
                expenseData?.account = accountLabel.text
                expenseData?.amount = Int32(amountTextField.text!) ?? 0
                expenseData?.category = categoryLabel.text
                expenseData?.dateStr = dateTextField.text
                expenseData?.isExpense = isExpenseCategory ?? true
                
                if let memo = memoTextField.text{
                    expenseData?.memo = memo
                }
                if let photoData = receiptPhotoImageView.image?.pngData(){
                    expenseData?.receiptPhoto = photoData
                }
                print("#### 更新，回去")
            }
        }
    }
    
    func showReceiptImageController() {
        if let controller = storyboard?.instantiateViewController(identifier: "\(ReceiptPhotoViewController.self)", creator: { coder in
            ReceiptPhotoViewController(coder: coder, receiptImageData: self.expenseData?.receiptPhoto)
        }){
            controller.modalPresentationStyle = .fullScreen
            show(controller, sender: nil)
        }
    }
    func updateUI() {
        //set segmentControl text Color
        segmentedControl.setTitleTextAttributes([.foregroundColor:UIColor(named: "MainColor") ?? UIColor.black], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor:UIColor.white], for: .normal)
        
        //set keyboard
        amountTextField.keyboardType = .numberPad
        amountTextField.setNumberKeyboardReturn()
        
        //set datepicker
        createDatePicker()
        
        //set Date
        dateTextField.text = selectedDate
        
        
        //載入 expenseData
        if let expenseData = expenseData{
            dateTextField.text = expenseData.dateStr
            
            if expenseData.amount == 0{
                amountTextField.text = ""
            }else{
                amountTextField.text = String(expenseData.amount)
            }
            categoryImageView.image = UIImage(named: "\(expenseData.category!)")
            categoryLabel.text = expenseData.category
            if expenseData.isExpense == true{
                segmentedControl.selectedSegmentIndex = 0
            }else{
                segmentedControl.selectedSegmentIndex = 1
            }
            isExpenseCategory = expenseData.isExpense
            accountImageView.image = UIImage(named: "\(expenseData.account!)")
            accountLabel.text = expenseData.account
            
            if expenseData.receiptPhoto != nil {
                receiptPhotoImageView.image = UIImage(data: expenseData.receiptPhoto!)
                
            }else if expenseData.memo != nil {
                memoTextField.text = expenseData.memo
            }
            
        }else{
            categoryLabel.text = Expense.expenseCategories.first?.rawValue
            categoryImageView.image = UIImage(named: Expense.expenseCategories.first?.rawValue ?? "")
            accountLabel.text = Expense.accounts.first?.rawValue
            accountImageView.image = UIImage(named: Expense.accounts.first?.rawValue ?? "")
        }
    }
    
    func didNotCompleteAlertController() {
        let controller = UIAlertController(title: "未填寫金額", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "確認", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    func dateFormatter(date:Date)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d, yyyy"
        return dateFormatter.string(from: date)
    }

    func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = setDatePickerReturn()
    }
    func setDatePickerReturn()->UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectDoneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space,doneBtn], animated: true)
        
        return toolBar
    }
    @objc func selectDoneButton(){
        dateTextField.text = dateFormatter(date: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func changeCategory(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isExpenseCategory = true
            expenseData?.isExpense = true
            expenseData?.category = Expense.expenseCategories.first?.rawValue
            categoryLabel.text = Expense.expenseCategories.first?.rawValue
            categoryImageView.image = UIImage(named: Expense.expenseCategories.first!.rawValue)
            
        }else{
            isExpenseCategory = false
            expenseData?.isExpense = false
            expenseData?.category = Expense.incomeCategories.first?.rawValue
            categoryLabel.text = Expense.incomeCategories.first?.rawValue
            categoryImageView.image = UIImage(named: Expense.incomeCategories.first!.rawValue)
        }
    }
    @IBAction func selectPhoto(_ sender: Any) {
        selectPhotoAlertController()
    }
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    @IBAction func unwindToAddExpenseScene(_ unwindSegue: UIStoryboardSegue) {
        
        if let _ = unwindSegue.source as? ReceiptPhotoViewController{
            receiptPhotoImageView.image = nil
            cameraBtn.isHidden = false
        }else if let categorySource = unwindSegue.source as? CategoryCollectionViewController,
                 let row = categorySource.row{
            
            if segmentedControl.selectedSegmentIndex == 0 {
                let category = Expense.expenseCategories[row].rawValue
                expenseData?.isExpense = true
                categoryImageView.image = UIImage(named: category)
                categoryLabel.text = category
            }else{
                let category = Expense.incomeCategories[row].rawValue
                expenseData?.isExpense = false
                categoryImageView.image = UIImage(named: category)
                categoryLabel.text = category
            }
        }else if let accountSource = unwindSegue.source as? AccountTableViewController,
                 let row = accountSource.row{
            let account = Expense.accounts[row].rawValue
            accountImageView.image = UIImage(named: account)
            accountLabel.text = account
        }
        tableView.reloadData()
    }
    @IBAction func unwindToAddExpenseSceneWithoutData(_ unwindSegue: UIStoryboardSegue) {
        
    }
    @IBSegueAction func categoryDetail(_ coder: NSCoder) -> CategoryCollectionViewController? {
        return CategoryCollectionViewController(coder: coder, isExpenseCategory: isExpenseCategory ?? true)
    }
}

extension AddExpenseItemTableViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
extension AddExpenseItemTableViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        receiptPhotoImageView.image = info[.originalImage] as? UIImage
        cameraBtn.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    func selectPhotoAlertController() {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let sources:[(sheetTitle:String, sourceType:UIImagePickerController.SourceType)] = [
            ("Album",.photoLibrary),
            ("Camera",.camera)
        ]
        for source in sources {
            let action = UIAlertAction(title: source.sheetTitle, style: .default) { _ in
                self.selectPhoto(sourceType: source.sourceType)
            }
            controller.addAction(action)
        }
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    func selectPhoto(sourceType:UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}
