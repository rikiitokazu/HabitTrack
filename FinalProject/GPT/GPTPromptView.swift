//
//  ContentView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 12/3/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Key: Identifiable, Codable {
    @DocumentID var id: String?
    var ai: String
    init(id: String? = nil, ai: String = "") {
        self.id = id
        self.ai = ai
    }
}

struct GPTPromptView: View {
    @FirestoreQuery(collectionPath: "keys") var keys: [Key]
    @State private var key: String = ""
    @State private var inputText: String = ""
    @State private var responseText: String = ""
    @State private var isLoading: Bool = false
    
    @Binding var habitName: String
    @Binding var frequency: FrequencyAmount
    @Binding var notes: String
    
    let aiService = AIService()
    
    @FocusState private var focused: Bool
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            Text("Use AI to help you...")
                .font(.caption)
                .foregroundStyle(.white)
                .italic()
                .padding(.leading, 10)
                .padding(.bottom, 4)
            HStack (alignment: .center){
                TextField("What's your goal?", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .italic()
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.8), lineWidth:1)
                    }
                    .autocorrectionDisabled()
                    .focused($focused)
                    
                Spacer()
                AsyncButton {
                    isLoading = true
                    getKey()
                    focused = false
                    responseText = await aiService.getAIResponse(prompt: inputText, key: key)
                    isLoading = false
                } label: {
                    HStack (spacing: 0) {
                        Image(systemName: "wand.and.stars")
                            .foregroundStyle(.white)
                        Spacer()
                            .frame(width: 3)
                        Text("AI")
                            .foregroundStyle(.white)
                            .cornerRadius(8)
                            .bold()
                    }
                   
                }
                .frame(width: 60, height: 34)
                .background(isLoading ? Color.gray : Color.blue)
            
            }
            VStack {
                ProgressView()
                    .opacity(isLoading ? 1 : 0)
                Text(responseText)
                    .italic()
                    .opacity(isLoading ? 0.5 : 1)
                    .foregroundStyle(.white)
                Button {
                    applySuggestions()
                } label: {
                   Text("Apply AI Suggestions")
                        .italic()
                        .bold()
                }
                .opacity(responseText.isEmpty ? 0 : 1)
                .disabled(responseText.isEmpty)
            }
            .frame(height: 140)

        }
        .padding()

    }
    private func getKey() {
        if keys.isEmpty {
            key = ""
        } else {
            key = keys[0].ai
        }
    }
    
    private func applySuggestions() {
        // Use regular expressions to extract parts of the string
        let habitPattern = #"Habit:\s*(.+)"#
        let frequencyPattern = #"Frequency:\s*(\d+)"#
        let notesPattern = #"\(per/day\)\n(.+)"#

        if let habitMatch = responseText.range(of: habitPattern, options: .regularExpression) {
            habitName = String(responseText[habitMatch]).replacingOccurrences(of: "Habit: ", with: "")
        }

        if let frequencyMatch = responseText.range(of: frequencyPattern, options: .regularExpression),
           let freqValue = Int(String(responseText[frequencyMatch]).replacingOccurrences(of: "Frequency: ", with: "")) {
            switch freqValue {
            case 1: frequency = .one
                break
            case 2: frequency = .two
                break
            case 3: frequency = .three
                break
            case 4: frequency = .four
                break
            default: frequency = .five
            }
        }

        if let perDayRange = responseText.range(of: "(per/day)") {
            notes = String(responseText[perDayRange.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            print("failure")
        }
    }
}


#Preview {
    GPTPromptView(habitName: .constant(""), frequency: .constant(.one), notes: .constant(""))
        .background(.black800)
}
