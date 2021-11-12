//
//  ExpenseListCell.swift
//  ExpenseTracker
//
//  Created by pratik on 12/11/21.
//

import UIKit

class ExpenseListCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var backVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backVw.layer.masksToBounds = true
        backVw.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
