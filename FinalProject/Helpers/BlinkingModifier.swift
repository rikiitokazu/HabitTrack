//
//  BlinkingModifier.swift
//  FinalProject
//
//  Created by Riki Itokazu on 12/4/24.
//

import SwiftUI


struct BlinkingModifier: ViewModifier {
    let duration: Double
    @State private var blinking: Bool = false

    func body(content: Content) -> some View {
        content
            .opacity(blinking ? 0.9 : 1)
            .animation(.easeInOut(duration: duration).repeatForever(), value: blinking)
            .onAppear {
                // Animation will only start when blinking value changes
                blinking.toggle()
            }
    }
}

extension View {
    func blinking(duration: Double = 1) -> some View {
        modifier(BlinkingModifier(duration: duration))
    }
}
