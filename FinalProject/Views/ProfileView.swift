//
//  ProfileView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 12/3/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
         VStack {
            HStack {
                VStack (alignment: .leading){
                    Text("John Doe")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .bold()
                        .minimumScaleFactor(0.5)
                    Text("\("johndoe@email.com")")
                        .foregroundStyle(.white)
                        .italic()
                }
                Spacer()
                VStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                    //                .symbolRenderingMode()
                        .frame(width: 100, height: 100)
                    
                    Button("Edit") {
                        
                    }
                }
            }
            
            Spacer()
                .frame(height: 70)
            
            VStack (alignment: .leading) {
                HStack (spacing: 0) {
                    Text("\(18)")
                        .font(.title)
                        .foregroundStyle(.blue200)
                        .foregroundStyle(.white)
                    Text(" Current Habits")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                
            
                Spacer()
                    .frame(height:70)
                
                HStack (spacing: 0){
                    Text("\(20)")
                        .foregroundStyle(.green)
                    Text(" Completed Habits")
                        .foregroundStyle(.white)
                }
                
                HStack (spacing: 0){
                    Text("\(3)")
                        .foregroundStyle(.red)
                    Text(" Missed Habits")
                        .foregroundStyle(.white)
                }
                

            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black700)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Back") {
                    // TODO: go back
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
