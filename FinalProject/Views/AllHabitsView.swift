//
//  AllHabitsView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/30/24.
//

import SwiftUI

struct AllHabitsView: View {
    @State private var dummyHabitPhotos = ["photo", "camera", "pencil", "pencil.circle"]
    @State private var imageIsLoading = false
    var body: some View {
        List(dummyHabitPhotos, id: \.self) { photo in
            LazyVStack (alignment: .leading) {
                VStack (alignment: .leading) {
                    Text("username")
                        .foregroundStyle(.white)
                    Text("11/8/4 4:52 PM")
                        .foregroundStyle(.white)
                }
                ZStack {
                    Color.clear
                    
                    // replaced to // if photoisLoading
                    if imageIsLoading {
                        VStack(alignment: .center) {
                            Rectangle()
                                .fill(.black600)
                                .frame(width: 330, height: 430)
                        }
                    } else {
                        ZStack (alignment: .topLeading) {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 330, height: 430)
                                .border(.blue300, width: 3)
                                
                            Image(systemName: "camera.fill")
                                .resizable()
                                .foregroundStyle(.blue800)
                                .frame(width: 100, height: 100)
                                .border(.blue300, width: 3)
                        }
                }
            }
            .frame(maxWidth: .infinity) // Expand ZStack to full width
            Text("Caption goes here....")
                .foregroundStyle(.white)
        }
        .padding()
        .task {
            //                await creatures.loadNextIfNeeed(creature: creature)
        }
        .listRowBackground(Color(.black700))
    }
        .background(.black700)
        .listStyle(.plain)
    
    //        if creatures.isLoading {
    //            ProgressView()
    //                .tint(.red)
    //                .scaleEffect(4)
    //        }
}
}

#Preview {
    AllHabitsView()
}
