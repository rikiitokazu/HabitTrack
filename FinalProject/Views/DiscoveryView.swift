//
//  AllHabitsView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/30/24.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct DiscoveryView: View {
    @FirestoreQuery(collectionPath: "photos") var photos: [HabitPhoto]
    @State private var data = Data()
    
    @State private var discoveryShow = true
    @State private var orderOfPhotos = true
    
    var body: some View {
        ZStack {
            List(sortedPhotos) { photo in
                LazyVStack (alignment: .leading) {
                    VStack (alignment: .leading) {
                        Text("\(photo.user)")
                            .foregroundStyle(.white)
                        Text("\(photo.dateCreated.formatted(date: .abbreviated, time: .shortened))")
                            .foregroundStyle(.white)
                    }
                    ZStack {
                        Color.clear
                        
                        ZStack (alignment: .topLeading) {
                            if orderOfPhotos {
                                backView(photo.backImageURLString)
                                frontView(photo.frontImageURLString)
                            } else {
                                backView(photo.frontImageURLString)
                                frontView(photo.backImageURLString)
                            }
                        }
                        
                    }
                    
                    .frame(maxWidth: .infinity) // Expand ZStack to full width
                    Text("\(photo.caption)")
                        .foregroundStyle(.white)
                }
                .padding()
                .task {
                    // await creatures.loadNextIfNeeed(creature: creature)
                }
                .listRowBackground(Color(.black700))
                .overlay {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color(.black500))
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            
            
            if photos.isEmpty {
                VStack {
                    Text("Loading photos...")
                        .foregroundStyle(.white)
                        .italic()
                        .bold()
                    Spacer()
                        .frame(height: 50)
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(3)
                }
            }
        }
        
    }
    
    var sortedPhotos: [HabitPhoto] {
        if photos.isEmpty {
            return []
        } else {
            return photos.sorted { $0.dateCreated > $1.dateCreated }
        }
    }
    
}



extension DiscoveryView {
    private func backView(_ backViewUrl: String) -> some View {
        let backUrl = URL(string: backViewUrl)
        return (
            AsyncImage(url: backUrl) { image in
                image
                    .resizable()
                    .frame(width: 330, height: 430)
                    .clipShape(RoundedRectangle(cornerRadius: 10)) 
                    .overlay {
                        RoundedRectangle(cornerRadius:10)
                            .stroke(Color.black)
                    }
            } placeholder: {
                Rectangle()
                    .fill(Color(.black500))
                    .frame(width: 330, height: 430)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black)
                            ProgressView()
                                .tint(.white)
                        }
                    }
                
                
            }
        )
    }
    
    
    private func frontView(_ frontViewUrl: String) -> some View {
        let frontUrl = URL(string: frontViewUrl)
        return (
            AsyncImage(url: frontUrl) { image in
                image
                    .resizable()
                    .frame(width: 130, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black)
                    }
            } placeholder: {
                Rectangle()
                    .fill(Color.black500)
                    .frame(width:130, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black)
                            ProgressView()
                                .tint(.white)
                        }
                        
                    }
            }
                .onTapGesture {
                    orderOfPhotos = !orderOfPhotos
                }
        )
    }
}
#Preview {
    DiscoveryView()
}
