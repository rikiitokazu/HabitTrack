//
//  MainView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/30/24.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct MainView: View {
    @FirestoreQuery(collectionPath: "users",
                    predicates: [.isEqualTo("userId", Auth.auth().currentUser?.uid ?? "")]) var users: [User]

    
    @State private var imageIsLoading = false
    @State private var data = Data()
    
    @State private var showCreateHabitSheet = false
    @State private var isProfileDrawerOpen = false
    @State private var showToDo = false
    
    
    var body: some View {
        // !Changed from NavigationView to Group
        Group {
            ZStack {
                VStack (spacing: 0){
                    header
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(.black600)
                                .frame(maxHeight: .infinity, alignment: .bottom)
                                .padding(.top, 30)
                            
                        }

                    
                    if showToDo {
                        NavigationStack {
                            ToDoHabitsView(user: users.isEmpty ? User() : users[0])
                        }
                    } else {
                        DiscoveryView()
                    }
                }
                if isProfileDrawerOpen {
                    Color.black.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isProfileDrawerOpen = false
                            }
                        }
                }
                
                ProfileNavView(isShowing: $isProfileDrawerOpen, user: users.isEmpty ? User() : users[0])
                
                if !showToDo && !isProfileDrawerOpen {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .symbolRenderingMode(.monochrome)
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.blue500)
                                .padding()
                                .onTapGesture {
                                    showCreateHabitSheet = true
                                }
                            
                        }
                    }
                }
            }
            .background(.black800)
            .listStyle(.plain)
            .sheet(isPresented: $showCreateHabitSheet) {
                NavigationStack {
                    CreateHabitView(habit: Habit())
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 50 {
                        withAnimation {
                            isProfileDrawerOpen = true
                        }
                    } else if value.translation.width < -50 {
                        withAnimation {
                            isProfileDrawerOpen = false
                        }
                    }
                }
        )
        //        if creatures.isLoading {
        //            ProgressView()
        //                .tint(.red)
        //                .scaleEffect(4)
        //        }
    }
}

extension MainView {
    private var header: some View {
        VStack (spacing: 0) {
            HStack (alignment: .center, spacing: 0){
                if !users.isEmpty && users[0].profilePic != nil {
                    let url = URL(string: users[0].profilePic!)
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 30, height: 30)
                    } placeholder: {
                        ProgressView()
                    }
                    .onTapGesture {
                        isProfileDrawerOpen = !isProfileDrawerOpen
                    }

                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.white)
                        .onTapGesture {
                            isProfileDrawerOpen = !isProfileDrawerOpen
                        }
                }
                
                
                Spacer()
                
                HStack (spacing: 0) {
                    Text("Habit")
                        .foregroundStyle(.white)
                    Text("Track.")
                        .foregroundStyle(.blue400)
                }
                .font(.title)
                .bold()
                .padding(.trailing, 30)
                
                
                Spacer()
                
                
                
            }
            .padding(.bottom)
            
            
            HStack {
                Button {
                    // trigger separate view
                    showToDo = true
                } label: {
                    Text("Your Habits")
                        .foregroundStyle(showToDo ? .white : .black100)
                        .overlay {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(showToDo ? .blue400 : .clear)
                                .frame(maxHeight: .infinity, alignment: .bottom)
                                .padding([.top], 30)
                        }
                }
                
                Spacer()
                    .frame(width: 50)
                
                Button {
                    // trigger separate view
                    showToDo = false
                } label: {
                    Text("Discovery")
                        .foregroundStyle(showToDo ? .black100 : .white)
                        .overlay {
                            Rectangle()
                                .frame(height: 2)
                                .foregroundStyle(showToDo ? .clear : .blue400)
                                .frame(maxHeight: .infinity, alignment: .bottom)
                                .padding([.top], 30)
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .padding()
        .background(.black700)
    }
}

#Preview {
    NavigationStack {
        MainView()
    }
}
