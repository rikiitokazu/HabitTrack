//
//  CreateHabitView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/27/24.
//

import SwiftUI
import Firebase
import FirebaseAuth



struct CreateHabitView: View {

    @State var habit: Habit
//    @State private var habitName = ""
//    @State private var frequency = 0
//    @State private var frequencyType: FrequencyType
//    @State private var notes = ""
//    @State private var isCompleted: Bool = false
//    @State private var dateCreated: Date = Date.now
//    @State private var completed: Int = 0
//    @State private var missed: Int = 0
//    @State private var lastCompleted: Date?
//    @State private var specificDays: [Date] = []
//    @State private var nextTime: [Date] = []
//    @State private var reminderIsOn: Bool = false
//    @State var specificTimes: [Int] = []
    @State private var test: FrequencyType = .daily
    
    //    @State private var dueDate = Date.now + 60*60*24
    @State private var dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        List {
            TextField("Enter a habit", text:$habit.habitName)
                .font(.title)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical)
                .listRowSeparator(.hidden)
                
            Picker("Select Frequency Type", selection: $habit.frequencyType) {
                ForEach(FrequencyType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized)
                }
            }
            Toggle("Set Reminder:", isOn: $habit.reminderIsOn)
                .padding(.top)
                .listRowSeparator(.hidden)
            
            DatePicker("Description:", selection:$habit.dateCreated)
                .listRowSeparator(.hidden)
                .padding(.bottom)
                .disabled(!false)
            
            Text("Notes:")
                .padding(.top)
            
            TextField("Notes", text: $habit.notes, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .listRowSeparator(.hidden)
            
            Toggle("Completed:", isOn: $habit.isCompleted)
                .padding(.top)
                .listRowSeparator(.hidden)
            
        }
        .listStyle(.plain)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    // save data
                    if Auth.auth().currentUser == nil {
                        print("-----Not logged in")
                        return
                    }
                    saveHabit()
                    dismiss()
                }
            }
        }
        
    }
    
    func saveHabit() {
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
    NavigationStack{
        CreateHabitView(habit: Habit())
    }
}
