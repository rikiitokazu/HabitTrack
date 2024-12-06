//
//  SignUpView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/19/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
   
    
    enum Field {
        case name, email, password
    }
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonDisabled = true
    @State private var presentMain = false
    @FocusState private var focusField: Field?
   
    @State private var userId: String?
    @State private var currentUser: User?
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            // Find suitable image
            Image(systemName: "pencil.tip")
                .resizable()
                .scaledToFit()
                .frame(width:80, height: 80)
            Spacer()
            Group {
                TextField("Name", text:$name)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .name)
                    .onSubmit {
                        focusField = .email
                    }
                
                TextField("Email", text:$email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of:email) {
                        enableButtons()
                    }
                
                SecureField("Password", text: $password)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil
                    }
                    .onChange(of:password) {
                        enableButtons()
                    }
                
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.8), lineWidth:2)
            }
            
            HStack {
                Button("Sign Up") {
                    register()
                }
                .padding(.leading)
                
                
            }
            .buttonStyle(.borderedProminent)
            .tint(.cyan)
            .font(.title2)
            .padding(.top)
            .padding(.bottom, 50)
            .disabled(buttonDisabled)
            
        }
        .padding()
        .background(.black600)
        .alert(alertMessage, isPresented: $showingAlert) {
            Button ("OK", role:.cancel) {}
        }
        .fullScreenCover(isPresented: $presentMain) {
            NavigationStack {
                MainView()
            }
        }
        .onChange(of: userId) {
            print("-----here ")
            print("Users: \(userId ?? "NOTHING")")
            if userId != nil {
                refreshUserHabits(userId: userId)
                presentMain = true
            }
        }
        .onAppear {
            userId = nil
        }
        .toolbar {
            ToolbarItem (placement: .topBarLeading) {
                Button("Back") {
                    dismiss()
                }
            }
        }
    }
    
    func enableButtons() {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonDisabled = !(emailIsGood && passwordIsGood)
        
    }
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("SIGNUP ERROR: \(error.localizedDescription)")
                alertMessage = "SIGNIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("Registrration success")
                Task {
                    guard let _ = await UserViewModel.saveUser(user: User(email: email, name: name)) else {
                        print("error: failed to save user")
                        return
                    }
                }
                presentMain = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
