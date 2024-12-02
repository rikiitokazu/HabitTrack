//
//  MainView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/30/24.
//

import SwiftUI
import PhotosUI

struct MainView: View {
    @State private var dummyHabitPhotos = ["photo", "camera", "pencil", "pencil.circle"]
    @State private var imageIsLoading = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var data = Data()
    @State private var pickerIsPresented = false
    @State private var selectedImage = Image(systemName: "photo")
    
    @State private var discoveryShow = true
    var body: some View {
        VStack {
            Group {
                HStack (alignment: .center){
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.white)
                    
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
                .padding([.trailing, .leading, .bottom])
                .padding(.top, 10)
                
                HStack {
                    Button {
                        // trigger separate view
                        discoveryShow = false
                    } label: {
                        Text("Your Habits")
                            .font(.title3)
                            .foregroundStyle(discoveryShow ? .black100 : .white)
                            .overlay {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundStyle(discoveryShow ? .clear : .blue400)
                                    .frame(maxHeight: .infinity, alignment: .bottom)
                                    .padding([.top], 30)
                            }
                    }
                    
                    Spacer()
                        .frame(width: 50)
                    
                    Button {
                        // trigger separate view
                        discoveryShow = true
                    } label: {
                        Text("Discovery")
                            .font(.title3)
                            .foregroundStyle(discoveryShow ? .white : .black100)
                            .overlay {
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundStyle(discoveryShow ? .blue400 : .clear)
                                    .frame(maxHeight: .infinity, alignment: .bottom)
                                    .padding([.top], 30)
                            }
                    }
                    
                }
            }
            .background(.black700)
            if discoveryShow {
                DiscoveryView()
            } else {
                ToDoHabitsView()
            }
        }
        .background(.black700)
        .listStyle(.plain)
        
        .photosPicker(isPresented: $pickerIsPresented, selection: $selectedPhoto)
        .onChange(of: selectedPhoto) {
            // turn selectedPhoto into imageView
            Task {
                do {
                    if let image = try await selectedPhoto?.loadTransferable(type: Image.self)
                    {
                        selectedImage = image
                    }
                    guard let transferredData = try await selectedPhoto?.loadTransferable(type: Data.self) else {
                        print("error could not convert data from selected Photo")
                        return
                    }
                    data = transferredData
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
        
        //        if creatures.isLoading {
        //            ProgressView()
        //                .tint(.red)
        //                .scaleEffect(4)
        //        }
    }
}


#Preview {
    MainView()
}
