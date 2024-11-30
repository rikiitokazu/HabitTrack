//
//  CountdownView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/29/24.
//

import SwiftUI
import AVFoundation

// View that countsdown before a photo is taken
// The background should be blue if its the front camera, and black if it
// is the back camera
struct CountdownView: View {
    @State var variation: AVCaptureDevice.Position
    @Binding var countdownFinished: Bool
    @Binding var VM: CameraViewModel
    @State private var countdown: Int = 3
    var body: some View {
        VStack {
            Spacer()
            Text(countdownFinished ? "hello" : "not hello")
            Text("Smile!")
                .font(.system(size: 40))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Spacer()
            Text("\(countdown)")
                .font(.system(size: 160))
                .fontWeight(.bold)
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand VStack to take full screen
        .background(variation == .front ? Color.blue : Color.black500) // Apply background color
        .ignoresSafeArea()
        .onAppear {
            startCountdown()
        }
    }
    
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 1 {
                countdown -= 1 // Decrease the countdown
            } else {
                timer.invalidate() // Stop the timer when countdown reaches 1
                withAnimation {
                    VM.takePhoto()
                    countdownFinished = !countdownFinished
                }
            }
        }
    }
}

#Preview {
    CountdownView(variation: .front, countdownFinished: .constant(false), VM: .constant(CameraViewModel()))
}
