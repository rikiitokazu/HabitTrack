//
//  ToDoHabitsView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/28/24.
//

import SwiftUI

import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ToDoHabitsView: View {
    @FirestoreQuery(collectionPath: "habits",
                    predicates: [.isEqualTo("userId", Auth.auth().currentUser?.uid ?? "")]) var habits: [Habit]
    //    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(getIncompleteHabits()) { habit in
                NavigationLink {
                    // Opens Camera View
                    
                } label: {
                    VStack {
                        HStack {
                            Text(habit.habitName)
                            Text("\(habit.completedForTheDay)/\(habit.frequency.rawValue)")
                        }
                        Image(systemName: getCorrectIcon())
                    }
                }
                // test buttons
                Button {
                    markAsDone(habit: habit)
                } label: {
                    Image(systemName: "plus")
                }
                Button {
                    removeOne(habit: habit)
                } label: {
                    Image(systemName: "plus")
                }
                
            }
            .listStyle(.plain)
            .navigationTitle("Habits to do")
        }
        
    }
    
    func getIncompleteHabits() -> [Habit] {
        // Separate into completed (for the day) and not completed
        // for the not completed, sort where completedForTheDay in ascending order
        let sortedHabits = habits.sorted { $0.progressForTheDay() < $1.progressForTheDay() }
      
        let incompleteHabits = sortedHabits.filter { $0.completedForTheDay < $0.frequency.rawValue }
        return incompleteHabits
    }
    
    func getCompletedHabits() -> [Habit] {
        let completedHabits = habits.filter { $0.completedForTheDay == $0.frequency.rawValue }
        
        return completedHabits
    }
    
    func getCorrectIcon() -> String {
        let time = Date.now
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        switch (hour, minute) {
        case (18...20, _):
            return "triangle"
        case (21, 0...59), (22...23, _):
            return "exclamationmark.circle"
        default:
            return "camera.fill"
        }
    }
    
    func markAsDone(habit: Habit) {
        print("increasing counter")
        habit.completedForTheDay += 1
        saveHabit(habit: habit)
    }
    
    func removeOne(habit: Habit) {
        print("decreasing counter")
        habit.completedForTheDay -= 1
        saveHabit(habit: habit)
    }
    
    func saveHabit(habit: Habit) {
        Task {
            guard let id = await HabitViewModel.saveHabit(habit: habit) else {
                print("error: failed to save habit")
                return
            }
            print("\(id)")
            
        }
    }
}

#Preview {
    ToDoHabitsView()
}
