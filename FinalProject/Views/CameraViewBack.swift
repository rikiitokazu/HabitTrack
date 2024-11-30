//
//  CameraViewBack.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/28/24.
//

import SwiftUI
import AVFoundation

struct CameraViewBack: View {
    @Binding var backPhoto: Data?
    @Binding var showCamera: Bool
    @Binding var cameraDisplay: AVCaptureDevice.Position
    
    @State private var countdownFinished: Bool = false
    @State private var VM = CameraViewModel()
    @State private var isActive = false
    let controlButtonWidth: CGFloat = 120
    let controlFrameHeight: CGFloat = 90
    var body: some View {
        Group {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                CountdownView(variation: .back, countdownFinished: $countdownFinished, VM: $VM)
//                horizontalControlBar
//                    .frame(height: controlFrameHeight)
            }
            .onAppear() {
                print("on appear triggered")
                VM.requestAcccessAndSetup(position: .back)
            }
            .onChange(of: countdownFinished) {
                // Wait 0.5 seconds, then set the VM.photo to the photo
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if VM.photoData == nil {
                        print("photo has not finished uploading")
                        return
                    }
                    showCamera = false
                    backPhoto = VM.photoData
                }
            }
        }
    }
    
//    private var cameraPreview: some View {
//        GeometryReader { geo in
//            CameraPreview(cameraVM: $VM, frame: geo.frame(in: .global))
//                .onAppear() {
//                    VM.requestAcccessAndSetup(position: cameraDisplay == .back ? .back : .front)
//                }
//        }
//        .ignoresSafeArea()
//    }
    
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
            backPhoto = VM.photoData

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
    CameraViewBack(backPhoto: .constant(nil), showCamera: .constant(true), cameraDisplay: .constant(.front))
}
