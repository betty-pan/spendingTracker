//
//  AddExpenseItemTableViewController.swift
//  spendingTracker
//
//  Created by Betty Pan on 2021/5/12.
//

import UIKit

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
    
    let dataCategorys = DataCategorys.allCases
    var expenseItem = ExpenseData(dateStr: "", amount: 0, category: ExpenseData.Category.init(incomeCategory: nil, expenseCategory: .food), account: .cash, receiptPhotoUrl: nil, memo: nil)
    
    var isExpenseCategory:Bool?
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let dataCategory = dataCategorys[indexPath.section]
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
        let amount = Int(amountTextField.text!) ?? 0
        expenseItem.amount = amount
        
        if let memo = memoTextField.text{
            expenseItem.memo = memo
        }
    }
    
    func showReceiptImageController() {
        if let controller = storyboard?.instantiateViewController(identifier: "\(ReceiptPhotoViewController.self)", creator: { coder in
            ReceiptPhotoViewController(coder: coder, receiptImageUrl: self.expenseItem.receiptPhotoUrl)
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
        
        //載入 expenseData
        dateTextField.text = expenseItem.dateStr
        
        if expenseItem.amount == 0{
            amountTextField.text = ""
        }else{
            amountTextField.text = String(expenseItem.amount)
        }
        if expenseItem.category.expenseCategory == nil{
            segmentedControl.selectedSegmentIndex = 1
            isExpenseCategory = false
            categoryImageView.image = UIImage(named: "\(expenseItem.category.incomeCategory!)")
            categoryLabel.text = expenseItem.category.incomeCategory?.rawValue
        }else{
            segmentedControl.selectedSegmentIndex = 0
            isExpenseCategory = true
            categoryLabel.text = expenseItem.category.expenseCategory?.rawValue
            categoryImageView.image = UIImage(named: "\(expenseItem.category.expenseCategory!)")
        }
        accountImageView.image = UIImage(named: "\(expenseItem.account)")
        accountLabel.text = expenseItem.account.rawValue
        
        ExpenseData.fetchReceiptImage(imageUrl: expenseItem.receiptPhotoUrl, imageView: receiptPhotoImageView)
        
        memoTextField.text = expenseItem.memo
    }
    
    func didNotCompleteAlertController() {
        let controller = UIAlertController(title: "未填寫金額", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "確認", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    func dateFormatStrNSave(date:Date)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d, yyyy"
        expenseItem.dateStr = dateFormatter.string(from: date)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d, yyyy"
        dateTextField.text = dateFormatStrNSave(date: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func changeCategory(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isExpenseCategory = true
            expenseItem.category.expenseCategory = ExpenseData.expenseCategories.first
            expenseItem.category.incomeCategory = nil
            categoryImageView.image = UIImage(named: "\(expenseItem.category.expenseCategory!)")
            categoryLabel.text = expenseItem.category.expenseCategory?.rawValue
        }else{
            isExpenseCategory = false
            expenseItem.category.incomeCategory = ExpenseData.incomeCategories.first
            expenseItem.category.expenseCategory = nil
            categoryImageView.image = UIImage(named: "\(expenseItem.category.incomeCategory!)")
            categoryLabel.text = expenseItem.category.incomeCategory?.rawValue
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
            expenseItem.receiptPhotoUrl = nil
            receiptPhotoImageView.image = nil
            cameraBtn.isHidden = false
        }else if let categorySource = unwindSegue.source as? CategoryCollectionViewController,
                 let row = categorySource.row{
            
            if segmentedControl.selectedSegmentIndex == 0 {
                let category = ExpenseData.expenseCategories[row]
                expenseItem.category = ExpenseData.Category(incomeCategory: nil, expenseCategory: category)
                categoryImageView.image = UIImage(named: "\(expenseItem.category.expenseCategory!)")
                categoryLabel.text = expenseItem.category.expenseCategory?.rawValue
            }else{
                let category = ExpenseData.incomeCategories[row]
                expenseItem.category = ExpenseData.Category(incomeCategory: category, expenseCategory: nil)
                categoryImageView.image = UIImage(named: "\(expenseItem.category.incomeCategory!)")
                categoryLabel.text = expenseItem.category.incomeCategory?.rawValue
            }
            
        }else if let accountSource = unwindSegue.source as? AccountTableViewController,
                 let row = accountSource.row{
            let account = ExpenseData.accounts[row]
            expenseItem.account = account
            accountImageView.image = UIImage(named: "\(expenseItem.account)")
            accountLabel.text = expenseItem.account.rawValue
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
        expenseItem.receiptPhotoUrl = info[.imageURL] as? URL
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
