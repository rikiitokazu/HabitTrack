//
//  Habit.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/27/24.
//

import Foundation
import SwiftData
import FirebaseFirestore
import FirebaseAuth

// TODO: What does the encodable and decodable do?
enum FrequencyAmount: Int, Encodable, Decodable, CaseIterable {
    case one = 1, two, three, four, five
}

class Habit: Identifiable, Codable {
    @DocumentID var id: String?
    var userId: String
    var habitName: String
    var frequency: FrequencyAmount
    var description: String
    var completedForTheDay: Int
    var dateCreated: Date
    var totalCompleted: Int
    var totalMissed: Int
    var reminderIsOn: Bool 
    var lastCompleted: Date?
    
    init(id: String? = nil, userId: String = (Auth.auth().currentUser?.uid ?? ""), habitName: String = "", frequency: FrequencyAmount = .one, description: String = "", completedForTheDay: Int = 0, dateCreated: Date = Date.now, totalCompleted: Int = 0, totalMissed: Int = 0, reminderIsOn: Bool = false, lastCompleted: Date? = nil) {
        self.userId = userId
        self.habitName = habitName
        self.frequency = frequency
        self.description = description
        self.completedForTheDay = completedForTheDay
        self.dateCreated = dateCreated
        self.totalCompleted = totalCompleted
        self.totalMissed = totalMissed
        self.reminderIsOn = reminderIsOn
        self.lastCompleted = lastCompleted
    }
    
    func progressForTheDay() -> Double {
        return Double(self.completedForTheDay) / Double(self.frequency.rawValue)
    }
}
