//
//  AllHabitsView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/30/24.
//

import SwiftUI
import PhotosUI

struct AllHabitsView: View {
    @State private var dummyHabitPhotos = ["photo", "camera", "pencil", "pencil.circle"]
    @State private var imageIsLoading = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var data = Data()
    @State private var pickerIsPresented = true
    @State private var selectedImage = Image(systemName: "photo")
    var body: some View {
        List(dummyHabitPhotos, id: \.self) { photo in
            LazyVStack (alignment: .leading) {
                VStack (alignment: .leading) {
                    Text("username")
                        .foregroundStyle(.white)
                    Text("11/8/4 4:52 PM")
                        .foregroundStyle(.white)
                }
                Button("Save image") {
                    Task {
                        await HabitPhotoViewModel.saveImage(habit: Habit(), photo: HabitPhoto(), data: data, display: .front)
                    }
                }
                ZStack {
                    Color.clear
  
                    selectedImage
                        .resizable()
                        .frame(width: 10, height: 10)
                    
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
    AllHabitsView()
}
