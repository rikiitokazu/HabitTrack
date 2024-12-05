//
//  TestView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/29/24.
//

import SwiftUI
import AVFoundation

struct CameraProcessView: View {
    @State var habit: Habit?
    
    @State private var frontPhoto: Data? = nil
    @State private var backPhoto: Data? = nil
    
    @State private var showFrontCamera: Bool = false
    @State private var showBackCamera: Bool = false
    
    @State private var photoDescription: String = ""
    
    @State private var cameraDisplay: AVCaptureDevice.Position = .front
    
    @State private var uploaded = false
    @State private var isUploading = false
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            VStack {
                VStack  {
                    HStack {
                        Text(habit?.habitName ?? "Habit Name")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Text("(\(habit?.frequency.rawValue ?? 2))")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    HStack {
                        if let frontPhoto, let uiImage = UIImage(data: frontPhoto) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.gray)
                        }
                        if let backPhoto, let uiImage2 = UIImage(data: backPhoto) {
                            Image(uiImage: uiImage2)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.gray)
                        }
                    }
                }
                Button("Document") {
                    showFrontCamera = true
                }
                .padding()
                
                Spacer()
                    .frame(height: 60)
                
                TextField("Caption...", text: $photoDescription)
                    .textFieldStyle(.roundedBorder)
                    .padding(.vertical)
                    .listRowSeparator(.hidden)
                
                Spacer()
                
                Button {
                   // upload photo
                    let newHabitPhoto = HabitPhoto(habitId: "\(habit?.id ?? "")", caption: photoDescription)
                    Task {
                        isUploading = true
                        await HabitPhotoViewModel.saveImage(habit: habit!, habitPhoto: newHabitPhoto, frontData: frontPhoto!, backData: backPhoto!)
                        isUploading = false
                        
                        uploaded = true
                    }

                    
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(.white)
                        Text("Upload")
                            .foregroundStyle(.white)
                    }
                    
                }
                .disabled(frontPhoto == nil || backPhoto == nil || photoDescription.isEmpty)
                
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .fullScreenFrontCamera(isPresented: $showFrontCamera, cameraDisplay: $cameraDisplay, frontPhoto: $frontPhoto, backPhoto: $backPhoto)
            .fullScreenCover(isPresented: $uploaded) {
                MainView()
            }
            .padding()
            
            if isUploading {
                ProgressView()
                    .tint(.blue)
                    .scaleEffect(2)
            }
        }
        .background(.black800)
        .onAppear {
            
        }

        

        
    }
}
extension View {
    func fullScreenFrontCamera(isPresented: Binding<Bool>, cameraDisplay: Binding<AVCaptureDevice.Position>, frontPhoto: Binding<Data?>, backPhoto: Binding<Data?>) -> some View {
        self.fullScreenCover(isPresented: isPresented, content: {
            CameraView(frontPhoto: frontPhoto, backPhoto: backPhoto, showCamera: isPresented, cameraDisplay: cameraDisplay)

        })
    }
}

#Preview {
    NavigationStack {
        CameraProcessView(habit: Habit(habitName: "Reading more", frequency: .three))
    }
}
