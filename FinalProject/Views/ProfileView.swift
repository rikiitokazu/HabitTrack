//
//  ProfileView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 12/3/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @State var user: User
    @Environment(\.dismiss) private var dismiss
    @State private var circularDoneAnimating = false
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage = Image(systemName: "photo")
    @State private var data = Data()
    var body: some View {
         VStack {
            HStack {
                VStack (alignment: .leading){
                    Text("\(user.name)")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .bold()
                        .minimumScaleFactor(0.5)
                    Text("\(user.email)")
                        .foregroundStyle(.white)
                        .italic()
                }
                Spacer()
                VStack {
                    
                    profilePicture
                    
                    PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                        Label("Edit", systemImage: "photo")
                    }
                    .onChange(of:selectedPhoto) {
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
                                await HabitPhotoViewModel.saveProfilePic(user: user, data: data)
                            } catch {
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    }

                }
            }
            .padding()
            
            Spacer()
                .frame(height: 70)
            
            VStack (alignment: .leading) {
                VStack {
                    HStack (spacing: 0) {
                        Text("\(18)")
                            .font(.title)
                            .foregroundStyle(.blue200)
                            .foregroundStyle(.white)
                            .italic()
                            .bold()
                        Text(" Current Habits")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .bold()
                    }
                }
                .overlay {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundStyle(.black300)
                        .frame(maxWidth: .infinity, alignment: .bottom)
                        .padding(.top, 50)
                }
                

                
            
                Spacer()
                    .frame(height:60)
                
                HStack (spacing: 0){
                    Text("\(20)")
                        .foregroundStyle(.green)
                        .font(.title2)
                        .italic()
                        .bold()
                    Text(" Completed Habits")
                        .foregroundStyle(.white)
                        .font(.title3)
                        .bold()
                }
                
                HStack (spacing: 0){
                    Text("\(3)")
                        .foregroundStyle(.red)
                        .font(.title2)
                        .italic()
                        .bold()
                    Text(" Missed Habits")
                        .foregroundStyle(.white)
                        .font(.title3)
                        .bold()
                }
                

            }
             
            Spacer()
            Text("Your Consistency: ")
                 .font(.title3)
                 .foregroundStyle(.white)
                 .bold()
            
             CircularAccuracy(color: .blue, consistency: 0.45, circularDoneAnimating: $circularDoneAnimating)
           
             Text("\(getAccuracyMessage(0.50))")
                 .foregroundStyle(.white)
                 .italic()
                 .bold()
                 .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black700)
        .onAppear {
            // Calculate information from the user
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Back") {
                    dismiss()
                }
            }
        }


    }
    
    func getAccuracyMessage(_ score: CGFloat) -> String {
        let newScore = score * 100
        if circularDoneAnimating {
            switch newScore {
            case 90...100:
                return "Amazing!"
            case 80...89:
                return "Great!"
            case 70...79:
                return "Decent!"
            case 60...69:
                return "Could be better!"
            case 50...59:
                return "Keep going!"
            default:
                return "Don't forget to remind yourself!"
            }
        }
        return ""
    }
}


extension ProfileView {
    var profilePicture: some View {
        VStack (spacing: 0) {
            if user.profilePic == nil {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
            } else {
                let url = URL(string: user.profilePic!)
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView()
                }
            }
        }
    }
        
}

#Preview {
    NavigationStack {
        ProfileView(user: User(email: "johndoe@email.com", name: "John Doe"))
    }
}
