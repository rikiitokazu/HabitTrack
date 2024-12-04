//
//  NavigationMenu.swift
//  FinalProject
//
//  Created by Riki Itokazu on 12/3/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ProfileNavView: View {
    @Binding var isShowing: Bool
    var edgeTransition: AnyTransition = .move(edge: .leading)
    
    
    // FullscreenCovers
    @State private var showProfileView = false
    @State private var showAllHabits = false
    @State private var showCreateHabit = false
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack(alignment: .leading) {
            if (isShowing) {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                ZStack{
                    Rectangle()
                        .fill(.black800)
                        .frame(width: 250, height: .infinity)
                        .shadow(color: .blue300, radius: 12, x: 0, y: 3)
                    
                    VStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .padding(.bottom, 30)
                        Text("\(Auth.auth().currentUser?.email ?? "No user")")
                            .font(.title3)
                            .bold()
                        
    //                    ForEach(NavigationDrawerRowType.allCases, id: \.self) { row in
    //                        RowView(isSelected: selectedNavigationItem == row.rawValue, imageName: row.iconName, title: row.title) {
    //                            selectedNavigationItem = row.rawValue
    //                            isDrawerOpen.toggle()
    //                        }
    //                    }
                        Spacer()
                            .frame(height:40)
                        VStack (alignment: .leading) {
                            Button {
                               
                            } label: {
                                Image(systemName: "brain.head.profile")
                                Spacer()
                                    .frame(width: 15)
                                Text("Profile")
                                    .bold()
                                Spacer()
                            }
                            .padding()
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "book")
                                Spacer()
                                    .frame(width:15)
                                Text("Your Habits")
                                    .bold()
                                Spacer()
                            }
                            .padding()
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "pencil")
                                Spacer()
                                    .frame(width:15)
                                Text("Create a Habit")
                                    .bold()
                                Spacer()
                            }
                            .padding()
                        }
                        
                        Spacer()
                        
                        Button {
                            do {
                                try Auth.auth().signOut()
                                print("Log out successful")
                                dismiss()
                            } catch {
                                print("ERROR: could not sign out")
                            }
                        } label: {
                            Image(systemName: "gearshape.fill")
                            Spacer()
                                .frame(width: 15)
                            Text("Sign out")
                                .bold()
                                .font(.title3)
                            Spacer()
                        }
                        .padding(30)
                        .background(.black)
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(.white.opacity(0.2))
                                .frame(maxHeight: .infinity, alignment: .top)
                        }
                    }
                    .padding(.top, 100)
                    .frame(width: 250)
                }
                .foregroundStyle(.white)
                .transition(edgeTransition)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 0.2), value: isShowing)
    }
}

#Preview {
    ProfileNavView(isShowing: .constant(true))
}
