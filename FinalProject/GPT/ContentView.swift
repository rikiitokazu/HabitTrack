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

struct ContentView: View {
    @FirestoreQuery(collectionPath: "keys") var keys: [Key]
    @State private var key: String = ""
    @State private var inputText: String = ""
    @State private var responseText: String = ""
    @State private var isLoading: Bool = false
    
    let aiService = AIService()
    
    var body: some View {
        VStack {
            TextField("Enter your prompt", text: $inputText)
                .autocorrectionDisabled()
                .padding()
                .border(Color.gray)
            
            AsyncButton {
                isLoading = true
                responseText = await aiService.getAIResponse(prompt: inputText, key: key)
                isLoading = false
            } label: {
                Text("Ask ai")
                    .padding()
                    .background(isLoading ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            VStack {
                ProgressView()
                    .opacity(isLoading ? 1 : 0)
                ScrollView {
                    Text(responseText)
                        .opacity(isLoading ? 0.5 : 1)
                }
            }
            
        }
        .onAppear {
            Task {
                key = keys[0].ai
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
