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
            Image(systemName: "person.crop.circle.fill")
                .resizable()
//                .symbolRenderingMode()
                .frame(width: 100, height: 100)
            Button("Change Profile Picture") {
                
            }
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
    ProfileView()
}
