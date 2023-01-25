//
//  Task.swift
//  TodoApp
//
//  Created by Alihan Karabayır on 17.01.2023.
//

import SwiftUI

// MARK: TASK MODEL
struct Task: Identifiable{
    var id : UUID = .init()
    var dateAdded : Date
    var taskName : String
    var taskDescription  :String
    var taskCategory : Category
}

var sampleTasks: [Task]=[
    .init(dateAdded: Date(timeIntervalSince1970: 1672829809), taskName: "Edit Video", taskDescription: "", taskCategory: .general)
   

]

