
//
//  DetailViewModel.swift
//  ToDoList
//
//  Created by Jatin Vashisht on 01/10/19.
//  Copyright © 2019 Jatin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import CoreData


class DetailViewModel {
    
    var updateFirebaseClosure: ((Bool)->())!
    // Core data context
    var context =  (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    
    //Update Fireabse DB
    func updateFireBaseDB (title : String , detail : String? , id : String) {
        let ref = Constants.refs.databaseTodo.child(id)
        let data = ["title":title , "detail":detail , "id":id]
        ref.updateChildValues(data as [AnyHashable : Any]) { (error, reff) in
            if error != nil {
                print(error!)
                self.updateFirebaseClosure(false)
                return
            }
            self.updateFirebaseClosure(true)
            print("success")
        }
        
    }
    
    //Update Local DB
    func updateToDoLocalDB (title : String , detail : String? , id : String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDO")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do{
            if let context = context{
                let result = try context.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    print(data.value(forKey: "id") as! String)
                    
                    let objectupdate = data
                    objectupdate.setValue(id, forKey: "id")
                    objectupdate.setValue(title, forKey: "title")
                    objectupdate.setValue(detail, forKey: "detail")
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
