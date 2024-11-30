//
//  CameraView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/28/24.
//

import SwiftUI

struct CameraView: View {
    @Binding var imageData: Data?
    @Binding var imageData2: Data?
    @Binding var showCamera: Bool
    @Binding var cameraDisplay: Bool 
    @State private var VM = CameraViewModel()
    @State private var isActive = false
    let controlButtonWidth: CGFloat = 120
    let controlFrameHeight: CGFloat = 90
    var body: some View {
        Group {
            
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack {
                    cameraDisplay ? Color.yellow : Color.blue
                    //               cameraPreview
                    // if we don't want allow retakes, just do usePhoto() after we take the pic
                    
                    horizontalControlBar
                        .frame(height: controlFrameHeight)
                }
            }
            .onAppear() {
                VM.requestAcccessAndSetup(position: cameraDisplay ? .back : .front)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        VM.takePhoto()
                    }
                }
            }
        }
    }
    
    private var cameraPreview: some View {
        GeometryReader { geo in
            CameraPreview(cameraVM: $VM, frame: geo.frame(in: .global))
                .onAppear() {
                    VM.requestAcccessAndSetup(position: cameraDisplay ? .back : .front)
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
            if cameraDisplay {
                imageData = VM.photoData
            } else {
                imageData2 = VM.photoData
            }
            showCamera = false
        }
    }
    
    private var retakeButton: some View {
        ControlButtonView(label: "Retake") {
            VM.retakePhoto()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    VM.takePhoto()
                    // boolean to show 1 or 2 view
                }
            }
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
    CameraView(imageData: .constant(nil), imageData2: .constant(nil), showCamera: .constant(true), cameraDisplay: .constant(false))
}
