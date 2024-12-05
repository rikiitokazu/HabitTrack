//
//  CameraView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/28/24.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @Binding var frontPhoto: Data?
    @Binding var backPhoto: Data?
    @Binding var showCamera: Bool
    @Binding var cameraDisplay: AVCaptureDevice.Position
    
    @State private var countdownFinished: Bool = false
    @State private var VM = CameraViewModel()
    var body: some View {
        Group {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                CountdownView(variation: .front, countdownFinished: $countdownFinished, VM: $VM)
            }
            .onAppear() {
                print("on appear triggered")
                VM.requestAcccessAndSetup(position: .front)
            }
            .onChange(of: countdownFinished) {
                // TODO: wait until the photoData has loaded. if its not, maybe
                // just do a ProgressView()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if VM.frontData == nil || VM.backData == nil {
                        print("photo has not finished uploading")
                        return
                    }
                    showCamera = false
                    frontPhoto = VM.frontData
                    backPhoto = VM.backData
                }
            }
        }
    }
    

}

#Preview {
    CameraView(frontPhoto: .constant(nil), backPhoto: .constant(nil), showCamera: .constant(true), cameraDisplay: .constant(.front))
}
