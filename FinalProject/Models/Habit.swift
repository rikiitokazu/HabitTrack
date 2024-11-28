//
//  Habit.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/27/24.
//

import Foundation
import SwiftData

@Model
class Habit {
    var habit: String = ""
    var frequency: Int = 0
    var frequencyType: String = ""
    var notes: String = ""
    var isCompleted: Bool = false
    var dateCreated: Date = Date.now
    var completed: Int = 0
    var missed: Int = 0
    var lastCompleted: Date?
    var specificDays: [Date] = []
    var specificTimes: [Int] = []
    var reminderIsOn: Bool = false
    
    init(habit: String = "", frequency: Int = 0, frequencyType: String = "", notes: String = "", isCompleted: Bool = false, dateCreated: Date = Date.now, completed: Int = 0, missed: Int = 0, lastCompleted: Date? = nil, specificDays: [Date] = [], specificTimes: [Int] = [], reminderIsOn: Bool = false) {
        self.habit = habit
        self.frequency = frequency
        self.frequencyType = frequencyType
        self.notes = notes
        self.isCompleted = isCompleted
        self.dateCreated = dateCreated
        self.completed = completed
        self.missed = missed
        self.lastCompleted = lastCompleted
        self.specificDays = specificDays
        self.specificTimes = specificTimes
        self.reminderIsOn = reminderIsOn
    }
    
}
