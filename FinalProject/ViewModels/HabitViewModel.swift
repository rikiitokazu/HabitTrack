//
//  HabitViewModel.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/28/24.
//

import Foundation
import FirebaseFirestore


@Observable
class HabitViewModel {
    
    static func saveHabit(habit: Habit) async -> String? {
        let db = Firestore.firestore()
        
        if let id = habit.id {
            do {
                try db.collection("habits").document(id).setData(from: habit)
                print("Data updated successfully")
                return id
            } catch {
                print("Could not update data in 'habits' \(error.localizedDescription)")
                return id
            }
            
        } else {
            do {
                let docRef = try db.collection("habits").addDocument(from: habit)
                print("Data added succesfully")
                return docRef.documentID
            } catch {
                print("Could not create a new spot in 'habits' \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    static func deleteHabit(habit: Habit) {
        let db = Firestore.firestore()
        guard let id = habit.id else {
            print("No habit.id")
            return
        }
        
        Task {
            do {
                try await db.collection("habits").document(id).delete()
            } catch {
                print("ERROR: Could not delete document \(id). \(error.localizedDescription)")
            }
        }
    }
}
