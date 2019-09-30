//
//  ViewModel.swift
//  ToDoList
//
//  Created by Jatin Vashisht on 9/30/19.
//  Copyright © 2019 Jatin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import CoreData

protocol Delegate {
    func dataFetchedFireBase( success : Bool , data : [ToDoModel])
    func dataFetchedLocalDb( success : Bool , data : [ToDoModel])
    func deleteitem (success : Bool , deletedId : String)
}

class DataViewModel {
    
    //clousure
    var savetoFirebaseClosure: ((Bool)->())!
    //customDelegate
    var delegate : Delegate?
    // Core data context
    var context =  (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    //Get Firebase Saved Data
    func getDataFromFirebase () {
        var dataModel = [ToDoModel]()
        let ref = Constants.refs.databaseTodo
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                for child in snapshot.children {
                    let td = ToDoModel()
                    if let snapshots = child as? DataSnapshot{
                        //                        td.id = snapshots.key
                        if let list = snapshots.value as? NSDictionary{
                            print(list)
                            td.title = list.value(forKey: "title") as? String
                            td.detail = list.value(forKey: "detail") as? String
                            td.id = list.value(forKey: "id") as? String
                        }
                    }
                    dataModel.append(td)
                }
                self.delegate?.dataFetchedFireBase(success: true, data: dataModel)
            }else{
                self.delegate?.dataFetchedFireBase(success: false, data: dataModel)
            }
        }
    }

    //Save Data to FireBase
    func saveFireBaseDB (title : String , detail : String? , id : String) {
        let ref = Constants.refs.databaseTodo.child(id)
        let data = ["title":title , "detail":detail , "id":id]
        ref.setValue(data, withCompletionBlock: { [weak self] (error, reff) in
            if error != nil {
                print(error!)
                self?.savetoFirebaseClosure(false)
                return
            }
            self?.savetoFirebaseClosure(true)
            print("success")
        })
    }
    
    //Save Data to LocalDB
    func saveToDoLocalDB (title : String , detail : String? , id : String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "ToDO", in: context!)
        let todo = NSManagedObject(entity: entity!, insertInto: context)
        todo.setValue(title, forKey: "title")
        todo.setValue(detail, forKey: "detail")
        todo.setValue(id, forKey: "id")
        
        do{
            try context!.save()
        }catch{
            fatalError("Error storing data")
        }
    }
    
    
    // Load data from  LocalDB
    func getDataFromLocalDB(){
        var dataModel = [ToDoModel]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDO")
        do{
            if let context = context{
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    print(data.value(forKey: "title") as! String)
                    let objc = ToDoModel(dicObject: data)
                    dataModel.append(objc)
                }
                self.delegate?.dataFetchedLocalDb(success: true, data: dataModel)
            }
        }catch{
            print("Error fetching data")
            self.delegate?.dataFetchedLocalDb(success: false, data: dataModel)
        }
    }
    
    //Delete list from Firebase
    func deleteItem(todoId : String) {
        let reference = Constants.refs.databaseTodo.child(todoId)
        reference.removeValue { (error, reff) in
            if error != nil {
                print(error!)
                self.delegate?.deleteitem(success: false, deletedId: "")
                return
            }
            self.delegate?.deleteitem(success: true, deletedId: todoId)
            print("success")
        }
    }
    
    //Delete list from LocalDB
    func deleteLocalDb(todoId : String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDO")
        fetchRequest.predicate = NSPredicate(format: "id == %@", todoId)
        
        do{
            if let context = context{
                let result = try context.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    print(data.value(forKey: "id") as! String)
                    
                    let objectdelete = data
                    context.delete(objectdelete)
                    do{
                        try context.save()
                    }catch{
                        fatalError("Error storing data")
                    }
                }
            }
        }catch{
            print("Error fetching data")
        }
    }
}
