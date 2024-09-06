//
//  Habit.swift
//  habitTracker
//
//  Created by Djordje Arandjelovic on 20.8.24..
//

import Foundation

struct Habit: Codable {
    var id: UUID
    var name: String
    var description: String
    var isCompleted: Bool
    var completionCount: Int
    
    init(name: String, description: String = "") {
        self.id = UUID()
        self.name = name
        self.description = description
        self.isCompleted = false
        self.completionCount = 0
    }
}
