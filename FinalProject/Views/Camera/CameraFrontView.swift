//
//  CameraFrontView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/28/24.
//

import SwiftUI
import AVFoundation

struct CameraFrontView: View {
    @Binding var frontPhoto: Data?
    @Binding var backPhoto: Data?
    @Binding var showCamera: Bool
    @Binding var cameraDisplay: AVCaptureDevice.Position
    
    @State private var countdownFinished: Bool = false
    @State private var VM = CameraViewModel()
    @State private var showBackView = false
    let controlButtonWidth: CGFloat = 120
    let controlFrameHeight: CGFloat = 90
    var body: some View {
        Group {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                CountdownView(variation: .front, countdownFinished: $countdownFinished, VM: $VM)
            }
            .fullScreenBackCamera(isPresented: $showBackView, cameraDisplay: $cameraDisplay, backPhoto: $backPhoto, showCamera: $showCamera)
            
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

extension View {
    func fullScreenBackCamera(isPresented: Binding<Bool>, cameraDisplay: Binding<AVCaptureDevice.Position>, backPhoto: Binding<Data?>, showCamera: Binding<Bool>) -> some View {
        self.fullScreenCover(isPresented: isPresented, content: {
            CameraBackView(backPhoto: backPhoto, showCamera: showCamera, cameraDisplay: cameraDisplay)

        })
    }
}

#Preview {
    CameraFrontView(frontPhoto: .constant(nil), backPhoto: .constant(nil), showCamera: .constant(true), cameraDisplay: .constant(.front))
}
