//
//  ViewController.swift
//  ExpenseTracker
//
//  Created by pratik on 12/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var objTbl: UITableView!
    @IBOutlet weak var bottomVw: UIView!
    @IBOutlet weak var btnDateSort: UIButton!
    @IBOutlet weak var lblTotalExpense: UILabel!
     
    var expenseList = [Expense]()

    override func viewDidLoad() {
        super.viewDidLoad()
        showPasscodeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
        bottomVw.isHidden = (expenseList.count > 0) ? false : true
    }

    @IBAction func btnAddExpense(_ sender: Any) {
        self.performSegue(withIdentifier: "add_expense", sender: self)
    }
    
    @IBAction func btnShowStateTap(_ sender: Any) {
        self.performSegue(withIdentifier: "show_states", sender: self)
    }
    @IBAction func btnSortByDate(_ sender: UIButton) {
      
        btnDateSort.isSelected = !sender.isSelected
        let order = (btnDateSort.isSelected) ? "DESC" : "ASC"
        expenseList = Expense.rowsFor(sql:"SELECT * FROM expenses  ORDER BY date \(order)")
        objTbl.reloadData()
    }
    
    @IBAction func btnSortByCate(_ sender: Any) {
        doSortingByCategory()
    }
    
    
    func fetchData(){
        expenseList = Expense.rowsFor(sql:"SELECT * FROM expenses")
        objTbl.reloadData()
    }
    
    func showPasscodeView(){
        PasscodeViewController.config.isRandomKeyEnabled = false
        PasscodeViewController.config.noOfDigits = 4
        
        let pass = Passcode.rowsFor(sql:"SELECT * FROM passcodes")
        
        if let vc = PasscodeViewController.instance(with: pass[0].Option == 0 ? .CREATE : (pass[0].Option == 1 ? .VERIFY : .CHANGE)) {
            vc.show(in: self) { (passcode, newPasscode, mode) in
                print(passcode, newPasscode, mode)
                
                if passcode.lowercased() == "biometric" {
                    vc.dismiss(animated: true, completion: nil)
                }  else {
                    vc.startProgressing()
                    if mode == .CREATE{
                        print( pass[0].delete(force: true))
                        let savePass = Passcode()
                        savePass.id = 0
                        savePass.Password = newPasscode
                        savePass.Option = 1
                        if savePass.save() != 0 {
                        }
                        vc.dismiss(animated: true, completion: nil)
                    }
                    else{
                        if pass[0].Password == passcode{
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                                vc.stopProgress()
                                vc.dismiss(animated: true, completion: nil)
                            }
                        }
                        else{
                            let alert = UIAlertController(title: "Alert", message: "Invalid Passcode, Please enter valid passcode", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func doSortingByCategory(){
        let actionSheetController: UIAlertController = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        
        for strCategory in SharedInstance.sharedInst.getCategory()
        {
            let firstAction = UIAlertAction(title: strCategory, style: .default ){ action -> Void in
                
                guard strCategory != "All" else{
                    self.fetchData()
                    return
                }
                
                self.expenseList = Expense.rowsFor(sql:"SELECT * FROM expenses WHERE Category = '\(strCategory)'")
                self.objTbl.reloadData()
            }
            actionSheetController.addAction(firstAction)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: .cancel) { action -> Void in }
        
        actionSheetController.addAction(cancelAction)
        present(actionSheetController, animated: true, completion: nil)
    }
    
    
}


//MARK:- UiTableView datasource and delegate

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseListCell") as! ExpenseListCell
        
        let Expense = expenseList[indexPath.row]
        cell.lblTitle.text = Expense.Title
        cell.lblCategory.text = Expense.Category
        cell.lblDate.text = Expense.Date
        cell.lblAmount.text = Expense.Amount
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
    }
    
    
}
    
 
