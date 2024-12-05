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
    enum CreateField {
        case habitName, frequency, notes
    }
    @State var habit: Habit
    @State private var dueDate = Calendar.current.date(byAdding: .day, value: 1, to: Date.now)!
    @State private var frequency: FrequencyAmount = .one
    
    @FocusState private var focusField: CreateField?
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            
            VStack {
                VStack (alignment: .leading, spacing: 0) {
                    Text("Habit Name:")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.bottom, 4)
                    TextField("Enter a habit", text: $habit.habitName)
                        .textFieldStyle(.roundedBorder)
                        .listRowSeparator(.hidden)
                        .submitLabel(.next)
                        .focused($focusField, equals: .habitName)
                        .onSubmit {
                            focusField = .frequency
                        }
                }
                .padding()
                HStack {
                    Text("Frequency (per/day)")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                        .bold()
                    Spacer()
                    Picker("", selection: $frequency) {
                        ForEach(FrequencyAmount.allCases, id: \.self) { num in
                            Text("\(num.rawValue)")
                                .foregroundStyle(.white)
                        }
                        .focused($focusField, equals: .frequency)
                        .onSubmit {
                            focusField = .notes
                        }
                    }
                }
                .padding()
                VStack (alignment: .leading, spacing: 0) {
                    Text("Notes:")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.bottom, 4)
                    
                    
                    TextField("Add a description/notes...", text: $habit.description)
                        .textFieldStyle(.roundedBorder)
                        .listRowSeparator(.hidden)
                        .submitLabel(.done)
                        .focused($focusField, equals: .notes)
                        .onSubmit {
                            focusField = nil
                        }
                }
                .padding()
                
//                Toggle("Set Reminder\(frequency == .one ? "" : "s"):", isOn: $habit.reminderIsOn)
//                    .foregroundStyle(.white)
//                    .font(.subheadline)
//                    .bold()
//                    .listRowSeparator(.hidden)
//                    .padding()
            }
            .overlay {
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.black500)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding([.top, .leading, .trailing])
            }
            
            
            GPTPromptView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black800)
        .ignoresSafeArea()
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
                    habit.frequency = frequency
                    if Auth.auth().currentUser == nil {
                        print("-----Not logged in")
                        return
                    }
                    saveHabit()
                    dismiss()
                }
            }
        }
        .onAppear() {
            // temporary workaround because enum not working
            frequency = habit.frequency
            
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
