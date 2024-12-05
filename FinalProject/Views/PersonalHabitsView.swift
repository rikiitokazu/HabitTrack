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
    var user: User
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List(habits) { habit in
            VStack {
                NavigationLink {
                    CreateHabitView(habit: habit)
                } label : {
                    VStack (alignment: .leading){
                        HStack (alignment: .center){
                            Image(systemName: "camera")
                            
                            Text(habit.habitName)
                                .bold()
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                        }
                        .padding([.bottom], 3)
                        
                        HStack (spacing: 0) {
                            Text("Completed:")
                                .font(.caption)
                                .foregroundStyle(.white)
                                .bold()
                            Text(" \(habit.completedForTheDay)/\(habit.frequency.rawValue)")
                                .font(.caption)
                            
                        }
                        
                        HStack (spacing: 0){
                            Text("Last Completed:")
                                .foregroundStyle(.white)
                                .font(.caption)
                                .bold()
                            
                            Text(" \(habit.lastCompleted?.formatted(date: .numeric, time: .shortened) ?? habit.dateCreated.formatted(date: .numeric, time: .shortened))")
                                .font(.caption)
                        }
                    }
                }
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        HabitViewModel.deleteHabit(habit: habit)
                    }
                }
                .foregroundStyle(.white)
                
            }
            .listRowBackground(Color(.black700))
        }
        .background(.black800)
        .listStyle(.plain)
        .foregroundStyle(.white)
        .toolbar {
            ToolbarItem (placement: .topBarLeading) {
                Button("Back") {
                    dismiss()
                }
            }
        }
        
    }
    
}

#Preview {
    NavigationStack {
        PersonalHabitsView(user: User(name: "John Doe"))
    }
}
