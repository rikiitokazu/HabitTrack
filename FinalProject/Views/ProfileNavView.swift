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
                        .shadow(color: .blue400.opacity(1), radius: 5, x: 0, y: 3)
                    
                    VStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .padding(.bottom, 30)
                        Text("\(Auth.auth().currentUser?.email ?? "No user") habits")
                        
    //                    ForEach(NavigationDrawerRowType.allCases, id: \.self) { row in
    //                        RowView(isSelected: selectedNavigationItem == row.rawValue, imageName: row.iconName, title: row.title) {
    //                            selectedNavigationItem = row.rawValue
    //                            isDrawerOpen.toggle()
    //                        }
    //                    }
                        VStack (alignment: .leading) {
                            Text("Navigations goes here")
                            Text("New Navigation")
                        }
                        Spacer()
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
