//
//  TaskCategory.swift
//  TodoApp
//
//  Created by Alihan Karabayır on 17.01.2023.
//

import SwiftUI

// MARK: Category Enum with Color

enum Category:String,CaseIterable{
    case general = "General"
    case bug = "Bug"
    case idea = "Idea"
    case Modifiers = "Modifiers"
    case challenge =  "Challenge"
    case coding = "Coding"
    
    var color: Color{
        switch self {
        case .general:
            return Color("Gray")
        case .bug:
            return Color("Green")
        case .idea:
            return Color("Pink")
        case .challenge:
            return Color.purple
        case .Modifiers:
            return Color("Blue")
        case .coding:
            return Color.brown
            
        }
    }
}
