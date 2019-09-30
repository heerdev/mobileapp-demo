//
//  ToDoItemCell.swift
//  ToDoList
//
//  Created by Jatin Vashisht on 9/30/19.
//  Copyright © 2019 Jatin. All rights reserved.
//

import UIKit

class ToDoItemCell: UITableViewCell {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var detailLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //set Table data
    var item : ToDoModel? {
        didSet {
            titleLbl.text = item?.title
            detailLbl.text = item?.detail
        }
    }
}
