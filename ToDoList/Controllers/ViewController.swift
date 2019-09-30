//
//  ViewController.swift
//  ToDoList
//
//  Created by Jatin Vashisht on 9/30/19.
//  Copyright © 2019 Jatin. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    
    // Items list to store todos
    var todoList = [ToDoModel]()
    
    // Core data context
    var context: NSManagedObjectContext?
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = DataViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            viewModel.getDataFromFirebase()
        }else{
            print("Internet Connection not Available!")
            viewModel.getDataFromLocalDB()
        }
        
    }
    
    //Add Entry Button
    @IBAction func addTodoPressed(_ sender: Any) {
        
        var itemTextField = UITextField()
        var detailsTextField = UITextField()
        
        let alert = UIAlertController(title: "Add Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Items", style: .default) { (action) in
            
            let title = itemTextField.text
            let details = detailsTextField.text
            
            if let title = title{
                let ref = Constants.refs.databaseTodo.childByAutoId()
                if Reachability.isConnectedToNetwork() {
                    self.viewModel.saveFireBaseDB(title: title, detail: details, id: "\(ref.key!)")
                }else{
                    self.alert(message: "No Internet Connection")
                }
                
                
                self.viewModel.savetoFirebaseClosure = { (success) in
                    if success == true {
                        let td = ToDoModel()
                        td.title = title
                        td.detail = details
                        td.id = "\(ref.key!)"
                        self.todoList.append(td)
                        if self.todoList.count > 0 {
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                        }
                        
                        self.viewModel.saveToDoLocalDB(title: title, detail: details, id: "\(ref.key!)")
                    }
                }
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add Todo Item"
            itemTextField = textField
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add Todo Details"
            detailsTextField = textField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegueId"{
            let detailVC = segue.destination as? DetailViewController
            if let row = sender as? Int {
                let detailTodo = todoList[row]
                detailVC?.detailData = detailTodo
            }
        }
    }
}

//MARK: UITableView

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ToDoItemCell
        cell.item = todoList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            //delete Todo
            if let todoId = self.todoList[indexPath.row].id {
                if Reachability.isConnectedToNetwork() {
                    self.viewModel.deleteItem(todoId: todoId)
                    self.todoList.remove(at: indexPath.row)
                }else{
                    self.alert(message: "No Internet Connection")
                }
                
            }
            
            
            completionHandler(true)
        })
        action.image = UIImage(named: "delete")
        action.backgroundColor = .red
        let confrigation = UISwipeActionsConfiguration(actions: [action])
        
        return confrigation
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailSegueId", sender: indexPath.row)
    }
}

//MARK: Custom Delegate

extension ViewController : Delegate {
    func deleteitem(success: Bool, deletedId: String) {
        if success == true {
            viewModel.deleteLocalDb(todoId: deletedId)
            self.alert(message: "Deleted Successfully")
            if self.todoList.count > 0 {
                self.tableView.reloadData()
            }else{
                self.tableView.isHidden = true
            }
        }else{
            self.alert(message: "Error during deletion")
        }
    }
    
    func dataFetchedFireBase(success: Bool, data: [ToDoModel]) {
        if success == true {
            todoList = data
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func dataFetchedLocalDb(success: Bool, data: [ToDoModel]) {    
        if success == true {
            todoList = data
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
}
