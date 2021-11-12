//
//  AddExpense.swift
//  ExpenseTracker
//
//  Created by pratik on 12/11/21.
//

import UIKit

class AddExpense: UIViewController {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtNotes: UITextField!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var txtCategory: UITextField!
    
    var datePicker: UIDatePicker!
    
    let categoryArr = ["Food", "Petrol"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func btnDateTap(_ sender: Any) {
        
        createDatePickerViewWithAlertController()
    }
    
    
    @IBAction func btnCategoryTap(_ sender: Any) {
        showCategoryList()
    }
    
    
    @IBAction func btnSave(_ sender: Any) {
        
        guard txtTitle.text != "" else {
            showAlert("Please enter title.")
            return
        }
        
        guard txtDate.text != "" else {
            showAlert("Please select date.")
            return
        }
        
        guard txtAmount.text != "" else {
            showAlert("Please enter amount.")
            return
        }
        
        guard txtCategory.text != "" else {
            showAlert("Please select category.")
            return
        }
        
        let expense = Expense()
        expense.Title = txtTitle.text ?? ""
        expense.Date = txtDate.text ?? ""
        expense.Amount = txtAmount.text ?? ""
        expense.Category = txtCategory.text ?? ""
        expense.Notes = txtNotes.text ?? ""
        
        if expense.save() != 0 {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    // MARK: - Alert View
    func showAlert(_ msg : String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Date Picker
    func createDatePickerViewWithAlertController()
    {
        let viewDatePicker: UIView = UIView(frame: CGRect(x:0,y: 0, width:self.view.frame.size.width, height :200))
        viewDatePicker.backgroundColor = UIColor.clear
        
        
        self.datePicker = UIDatePicker(frame: CGRect(x:0,y: 0,width: self.view.frame.size.width,height: 200))
        self.datePicker.datePickerMode = .date
        self.datePicker.minimumDate = Date()
        
        
        viewDatePicker.addSubview(self.datePicker)
        
        let alertController = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        alertController.view.addSubview(viewDatePicker)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: .cancel)
        { (action) in
            // ...
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Done", style: .default)
        { (action) in
            
            self.dateSelected()
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
        {
            // ...
        }
        
    }
    
    @objc func dateSelected()
    {
        var selectedDate: String = String()
        
        selectedDate =  self.dateformatterDateTime(date: self.datePicker.date)
        self.datePicker.setDate(self.datePicker.date, animated: true)
        txtDate.text = selectedDate
    }
    
    func dateformatterDateTime(date: Date) -> String
    {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    
    func showCategoryList(){
        let actionSheetController: UIAlertController = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        
        for strCategory in SharedInstance.sharedInst.getCategory()
        {
            let firstAction = UIAlertAction(title: strCategory, style: .default ){ action -> Void in
                self.txtCategory.text = strCategory
            }
            actionSheetController.addAction(firstAction)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: .cancel) { action -> Void in }
        
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
    }
    
}
