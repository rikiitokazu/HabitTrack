//
//  LoginView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/19/24.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct LoginView: View {
    enum Field {
        case email, password
    }
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonDisabled = true
    @State private var presentSheet = false
    @FocusState private var focusField: Field?
    
    
    var body: some View {
        VStack {
            // Find suitable image
            Image(systemName: "pencil.tip")
                .resizable()
                .scaledToFit()
                .frame(width:80, height: 80)
            Spacer()
            Group {
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
                
                Button("Log In") {
                    login()
                    // TODO: check last login. if current date is not equal to date of last login, reset counters and
                    // calculate all the missed habits
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
        .onAppear() {
            if Auth.auth().currentUser != nil {
                print("Log in successful")
                presentSheet = true
            }
        }
//        .fullScreenCover(isPresented: $presentSheet) {
//            
//        }
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
                presentSheet = true
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password:password) { result, error in
            if let error = error {
                print("LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("Login success")
                refreshUserHabits()
                presentSheet = true
            }
        }
    }
}

#Preview {
    LoginView()
}
