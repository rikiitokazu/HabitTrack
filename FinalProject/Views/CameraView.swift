//
//  CameraView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/28/24.
//

import SwiftUI

struct CameraView: View {
    @Binding var imageData: Data?
    @Binding var showCamera: Bool
    @State private var VM = CameraViewModel()
    let controlButtonWidth: CGFloat = 120
    let controlFrameHeight: CGFloat = 90
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
               cameraPreview
               horizontalControlBar
                    .frame(height: controlFrameHeight)
            }
        }
    }
    
    private var cameraPreview: some View {
        GeometryReader { geo in
            CameraPreview(cameraVM: $VM, frame: geo.frame(in: .global))
                .onAppear() {
                    VM.requestAcccessAndSetup()
                }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder private var horizontalControlBar: some View {
        if VM.hasPhoto {
            horizontalControlBarPostPhoto
        } else {
            horizontalControlBarPrePhoto
        }
    }
    
    private var horizontalControlBarPrePhoto: some View {
        HStack {
             cancelButton
                .frame(width: controlButtonWidth)
             Spacer()
             photoCaptureButton
             Spacer()
            Spacer()
                .frame(width: controlButtonWidth)
        }
    }
    
    private var horizontalControlBarPostPhoto: some View {
        HStack {
            retakeButton
                .frame(width: controlButtonWidth)
            Spacer()
            usePhotoButton
                .frame(width: controlButtonWidth)
        }
    }
    
    private var usePhotoButton: some View {
        ControlButtonView(label: "Use Photo") {
            imageData = VM.photoData
            showCamera = false
        }
    }
    
    private var retakeButton: some View {
        ControlButtonView(label: "Cancel") {
            VM.retakePhoto()
        }
    }
    
    private var cancelButton: some View {
        ControlButtonView(label: "Cancel") {
            showCamera = false
        }
    }
    
    private var photoCaptureButton: some View {
        Button {
            VM.takePhoto()
        } label: {
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 65)
                Circle()
                    .stroke(.white, lineWidth: 3)
                    .frame(width: 75)
            }
        }
    }
}

#Preview {
    CameraView(imageData: .constant(nil), showCamera: .constant(true))
}
