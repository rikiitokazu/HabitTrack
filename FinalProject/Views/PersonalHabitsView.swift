//
//  PersonalHabitsView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/28/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct PersonalHabitsView: View {
    @FirestoreQuery(collectionPath: "habits",
                    predicates: [.isEqualTo("userId", Auth.auth().currentUser?.uid ?? "")]) var habits: [Habit]
//    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(habits) { habit in
                NavigationLink {
                   CreateHabitView(habit: habit)
                } label: {
                    Text(habit.habitName)
                }
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        HabitViewModel.deleteHabit(habit: habit)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("\(Auth.auth().currentUser?.email ?? "No user") habits")
        }
    }
    
}

#Preview {
    PersonalHabitsView()
}
