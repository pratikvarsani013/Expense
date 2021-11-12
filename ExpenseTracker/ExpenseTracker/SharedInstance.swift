//
//  SharedInstance.swift
//  ExpenseTracker
//
//  Created by pratik on 12/11/21.
//

import Foundation
import UIKit
  
class SharedInstance {
     
    class var sharedInst: SharedInstance
    {
        struct Static
        {
            static let instance = SharedInstance()
        }
        return Static.instance
    }
    
    func getCategory() -> [String] {
        return ["All","Food", "Petrol", "Vegetable", "Recharge", "electricity"]
    }
    
    func dateformatterDateTime(date: Date) -> String
    {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func setDefaultPasscode(){
        
        guard Passcode.rowsFor(sql:"SELECT * FROM passcodes").count == 0 else {
            return
        }
        
        let pass = Passcode()
        pass.id = 1
        pass.Password = ""
        pass.Option = 0
        
        if pass.save() != 0 {
        }
    }
    
    func getTotalSpend() -> [Expense]{
        var totalSpend = [Expense]()
        totalSpend = Expense.rowsFor(sql:"""
            SELECT  cast(SUM(Amount) as text) as Amount,
                expenses.Category
            FROM expenses
            """)
        return totalSpend
    }
}





