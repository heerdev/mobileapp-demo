//
//  Constants.swift
//  ToDoList
//
//  Created by Jatin Vashisht on 9/30/19.
//  Copyright © 2019 Jatin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseTodo = databaseRoot.child("todo")
    }
}

// Display Alert
extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

