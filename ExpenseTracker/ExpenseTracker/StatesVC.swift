//
//  StatesVC.swift
//  ExpenseTracker
//
//  Created by pratik on 12/11/21.
//

import UIKit

class StatesVC: UIViewController {
    
    @IBOutlet weak var objTbl: UITableView!
    @IBOutlet weak var lblTotal: UILabel!
    
    var expenseList = [Expense]()
   

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
    }
    
    func fetchData(){
        
        //Fetch data by category
        expenseList = Expense.rowsFor(sql:"""
            SELECT  cast(SUM(Amount) as text) as Amount,
                  expenses.Category
            FROM expenses
            GROUP by Category
            """)
        objTbl.reloadData()
        
        let total = SharedInstance.sharedInst.getTotalSpend()
        lblTotal.text = "Total Spend : \(total[0].Amount)"
    }
    
}


//MARK:- UiTableView datasource and delegate

extension StatesVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell") as! stateCell
        
        let Expense = expenseList[indexPath.row]
        cell.lblCategory.text = Expense.Category
        cell.lblAmount.text = Expense.Amount
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
    }
    
    
}
