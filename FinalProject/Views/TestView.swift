//
//  TestView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/29/24.
//

import SwiftUI
import AVFoundation

enum CurrentView {
    case takingFrontPhoto
    case takingBackPhoto
    case final
}

struct TestView: View {
    @State private var frontPhoto: Data? = nil
    @State private var backPhoto: Data? = nil
    
    @State private var showFrontCamera: Bool = false
    @State private var showBackCamera: Bool = false
    
    @State private var cameraDisplay: AVCaptureDevice.Position = .front
    var body: some View {
        VStack {
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
            Button("Start the process") {
                // TODO: set showCamera = false to cancel the process
                // 1) camera view for front
                // 2) camera view for back
                showFrontCamera = true
            }
//            Button("Take Upper Photo") {
//                cameraDisplay = .front
//                showCamera = true
//            }
//            .disabled(frontPhoto != nil)
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
            Button("Take Bottom Photo") {
                cameraDisplay = .back
                showBackCamera = true
            }
            .disabled(backPhoto != nil)
            .fullScreenFrontCamera(isPresented: $showFrontCamera, cameraDisplay: $cameraDisplay, frontPhoto: $frontPhoto, backPhoto: $backPhoto)
            .padding()
        }
        .padding()
    }
}
extension View {
    func fullScreenFrontCamera(isPresented: Binding<Bool>, cameraDisplay: Binding<AVCaptureDevice.Position>, frontPhoto: Binding<Data?>, backPhoto: Binding<Data?>) -> some View {
        self.fullScreenCover(isPresented: isPresented, content: {
            CameraViewFront(frontPhoto: frontPhoto, backPhoto: backPhoto, showCamera: isPresented, cameraDisplay: cameraDisplay)

        })
    }
}

#Preview {
    TestView()
}
