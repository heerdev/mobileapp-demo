//
//  Model.swift
//  ToDoList
//
//  Created by Jatin Vashisht on 9/30/19.
//  Copyright © 2019 Jatin. All rights reserved.
//

import Foundation
import CoreData

class ToDoModel {
    var title : String?
    var detail : String?
    var id : String?
    init () {
        
    }
    
    init (dic : NSDictionary){
        self.title = dic.value(forKey: "title") as? String
        self.detail = dic.value(forKey: "detail") as? String
        self.id = dic.value(forKey: "id") as? String
    }
    
    init (dicObject :NSManagedObject) {
        self.title = dicObject.value(forKey: "title") as? String
        self.detail = dicObject.value(forKey: "detail") as? String
        self.id = dicObject.value(forKey: "id") as? String
    }
}
