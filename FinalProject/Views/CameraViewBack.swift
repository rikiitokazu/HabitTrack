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
            }
            .onAppear() {
                print("on appear triggered")
                VM.requestAcccessAndSetup(position: .back)
            }
            .onChange(of: countdownFinished) {
                // TODO: refactor this part
                // Wait 1 seconds, then set the VM.photo to the photo
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
    
}

#Preview {
    CameraViewBack(backPhoto: .constant(nil), showCamera: .constant(true), cameraDisplay: .constant(.front))
}
