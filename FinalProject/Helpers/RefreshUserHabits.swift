//
//  RefreshUserHabits.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/28/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore


func refreshUserHabits(userId: String?) {
    @FirestoreQuery(collectionPath: "habits",
                    predicates: [.isEqualTo("userId", userId ?? "")]) var habits: [Habit]
    @FirestoreQuery(collectionPath: "users",
                    predicates: [.isEqualTo("userId", userId ?? "")]) var users: [User]

    guard let user = users.first else {
        print("can't do users.first")
        return
    }
    if isSameDate(as: user.lastLogin) {
        print("---same date, no need to refresh")
        return
    }
    
    // For each habit, calculate the amount of habits missed
    // Then, update the completedForTheDay to 0
    for habit in habits {
        missesInDay(habit: habit, start: user.lastLogin)
        resetCompletedForTheDay(habit: habit)
    }
    
    
    // Update user.lastLogin to be now
    updateLastLogin(user: user)
}


func isSameDate(as date: Date) -> Bool {
    let calendar = Calendar.current
    let today = Date()
    
    // Extract year, month, and day components from both dates
    let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
    let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)

    // Compare the components
    return todayComponents == dateComponents
}


func missesInDay(habit: Habit, start: Date)  {
    let calendar = Calendar.current
    var today = Date()
    // First, calculate the amount of misses from last signed in date, which is just freq - completedInADay
    let remainder = habit.frequency.rawValue - habit.completedForTheDay
    habit.totalMissed += remainder
    
    // M T W T F
    // lets say user completed 2/5 on monday, and signs in on friday. Expected should be 18, since we don' want to count Friday
    var current = calendar.date(byAdding: .day, value: 1, to: start)!
    current = calendar.date(byAdding: .second, value: 2, to: current)!
    today = calendar.date(byAdding: .day, value: -1, to: today)!
    while current < today {
        print("Processing date: \(current)")
        // Increment by one day
        if let nextDay = calendar.date(byAdding: .day, value: 1, to: current) {
            habit.totalMissed += (habit.frequency.rawValue)
            current = nextDay
        } else {
            break
        }
    }
    
    Task {
        guard let _ = await HabitViewModel.saveHabit(habit: habit) else {
            print("error: failed to save habit")
            return
        }
    }
    
}

func resetCompletedForTheDay(habit: Habit) {
    habit.completedForTheDay = 0
    Task {
        guard let _ = await HabitViewModel.saveHabit(habit: habit) else {
            print("failed to save habit")
            return
        }
    }
}

func updateLastLogin(user: User) {
    user.lastLogin = Date.now
    Task {
        guard let _ = await UserViewModel.saveUser(user: user) else {
            print("failed to save habit")
            return
        }
    }
}

