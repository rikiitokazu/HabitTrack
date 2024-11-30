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
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CountdownView(variation: .front)
}
