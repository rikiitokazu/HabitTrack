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
    var body: some View {
        VStack {
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
            Button("Document now") {
                // TODO: cancel the process midway
                showFrontCamera = true
            }
            // TODO: onAppear -> showFrontCamera = true?
            // if false,  
            .disabled(backPhoto != nil)
            .padding()
            
            Spacer()
            
            TextField("Description...", text: $photoDescription)
                .textFieldStyle(.roundedBorder)
                .padding(.vertical)
                .listRowSeparator(.hidden)
            
            Spacer()
            
            Button {
               // upload photo
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Upload")
                }
                
            }
            .disabled(frontPhoto == nil || backPhoto == nil || photoDescription.isEmpty)
            
            Spacer()
        }
        .fullScreenFrontCamera(isPresented: $showFrontCamera, cameraDisplay: $cameraDisplay, frontPhoto: $frontPhoto, backPhoto: $backPhoto)
        .padding()
    }
}
extension View {
    func fullScreenFrontCamera(isPresented: Binding<Bool>, cameraDisplay: Binding<AVCaptureDevice.Position>, frontPhoto: Binding<Data?>, backPhoto: Binding<Data?>) -> some View {
        self.fullScreenCover(isPresented: isPresented, content: {
            CameraFrontView(frontPhoto: frontPhoto, backPhoto: backPhoto, showCamera: isPresented, cameraDisplay: cameraDisplay)

        })
    }
}

#Preview {
    CameraProcessView(habit: Habit())
}
