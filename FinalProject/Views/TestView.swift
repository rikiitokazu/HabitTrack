//
//  TestView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/29/24.
//

import SwiftUI
import AVFoundation

struct TestView: View {
    @State private var imageData: Data? = nil
    @State private var imageData2: Data? = nil
    @State private var showCamera: Bool = false
    
    // if false, front camera. if true, back camera
    @State private var cameraDisplay: AVCaptureDevice.Position = .front
    var body: some View {
        VStack {
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.gray)
            }
            Button("Take Upper Photo") {
                cameraDisplay = .front
                showCamera = true
            }
            if let imageData2, let uiImage2 = UIImage(data: imageData2) {
                Image(uiImage: uiImage2)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.gray)
            }
            Button("Take Bottom Photo") {
                cameraDisplay = .back
                showCamera = true
                
            }
            .fullScreenCamera(isPresented: $showCamera, cameraDisplay: $cameraDisplay, imageData: $imageData, imageData2: $imageData2)
            .padding()
        }
        .padding()

    }
}
extension View {
    func fullScreenCamera(isPresented: Binding<Bool>, cameraDisplay: Binding<AVCaptureDevice.Position>, imageData: Binding<Data?>, imageData2: Binding<Data?>) -> some View {
        self.fullScreenCover(isPresented: isPresented, content: {
            CameraView(imageData: imageData, imageData2: imageData2, showCamera: isPresented, cameraDisplay: cameraDisplay)
        })
    }
}

#Preview {
    TestView()
}
