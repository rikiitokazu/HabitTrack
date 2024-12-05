//
//  CircularAccuracy.swift
//  FinalProject
//
//  Created by Riki Itokazu on 12/4/24.
//

import SwiftUI

struct CircularAccuracy: View {
    @State var color: Color
    @State var consistency: CGFloat = 0.0
    @Binding var circularDoneAnimating: Bool
    
    @State private var progress: CGFloat = 0.0
    @State private var number: Int = 0
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 30)
                    .opacity(0.1)
                    .foregroundStyle(color)
                
                Text("\(number)%")
                    .foregroundStyle(.white)
                    .italic()
                    .bold()
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round))
                    .foregroundStyle(color)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.linear(duration: 2), value: progress)
            }
            .frame(width: 130, height:130)
            .padding()
        }
        .onAppear {
            progress = consistency
            withAnimation(.easeOut(duration: 2)) {
                for i in 1...Int(consistency * 100) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.032) {
                        number = i
                    }
                }
                circularDoneAnimating = true
            }
            
            
        }
    }
}


#Preview {
    CircularAccuracy(color: .green, consistency: 0.9, circularDoneAnimating: .constant(true))
}
