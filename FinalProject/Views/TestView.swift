//
//  TestView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/29/24.
//

import SwiftUI

struct TestView: View {
    @State private var imageData: Data? = nil
    @State private var showCamera: Bool = false
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
            Button("Take Photo") {
                showCamera = true
            }
            .fullScreenCamera(isPresented: $showCamera, imageData: $imageData)
            .padding()
        }
        .padding()

    }
}


#Preview {
    TestView()
}
