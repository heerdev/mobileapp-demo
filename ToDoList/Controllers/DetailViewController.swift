//
//  DetailViewController.swift
//  ToDoList
//
//  Created by Jatin Vashisht on 30/09/19.
//  Copyright © 2019 Jatin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var detailData : ToDoModel?
    
    @IBOutlet weak var titleTxtfld: UITextField!
    @IBOutlet weak var detailTxtview: UITextView!
    @IBOutlet weak var editButn: UIBarButtonItem!
    
    let viewModel = DetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTxtfld.text = detailData?.title
        detailTxtview.text = detailData?.detail
        self.editButn.title = "Edit"
        
    }
    
    @IBAction func editBtnClicked(sender: Any) {
        
        if editButn.title == "Save"{
            if let todoId = detailData?.id {
                
                let title = titleTxtfld.text
                let desc = detailTxtview.text
                if title!.count < 1 {
                    self.alert(message: "Please Enter Title")
                    return
                }
                if Reachability.isConnectedToNetwork() {
                    viewModel.updateFireBaseDB(title: title ?? "", detail: desc, id: todoId)
                }else{
                    self.alert(message: "No Internet Connection")
                }
                
                self.viewModel.updateFirebaseClosure = { (success) in
                    if success == true {
                        self.viewModel.updateToDoLocalDB(title: title!, detail: desc, id: todoId)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }else{
            titleTxtfld.isUserInteractionEnabled = true
            detailTxtview.isUserInteractionEnabled = true
            self.editButn.title = "Save"
        }
    }
}
