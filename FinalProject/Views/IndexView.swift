//
//  IndexView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/19/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct IndexView: View {
   
    @State private var presentLogin: Bool = false
    @State private var presentSignUp: Bool = false
    var body: some View {
        VStack (alignment: .center){
            Text("Welcome")
                .font(.system(size: 50))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .bold()
                .foregroundStyle(.white)
            Text("Get started with your habits!")
                .font(.caption)
                .foregroundStyle(.blue400)
            
            Image("logowhite")
                .resizable()
                .scaledToFit()
            
            
            HStack {
                Button("Sign Up") {
                    presentSignUp = true
                }
                .tint(.blue500)
                
                Button("Log In") {
                    presentLogin = true
                }
                .padding(.leading)
                .tint(.blue400)
                
                
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
            .padding(.bottom, 50)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(
            LinearGradient(colors: [Color(.black800), Color(.black500)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .onAppear() {
            // some animations
        }
        .fullScreenCover(isPresented: $presentLogin) {
            NavigationStack {
                LoginView()
            }
        }
        .fullScreenCover(isPresented: $presentSignUp) {
            NavigationStack {
                SignUpView()
            }
        }
        
    }
    
}

#Preview {
    IndexView()
}
