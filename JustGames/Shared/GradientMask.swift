//
//  GradientMask.swift
//  JustGames
//
//  Created by Ali Dinç on 05/01/2024.
//

import SwiftUI

struct GradientMaskView: View {
    
    var height: CGFloat
    var color: Color
    var alignment: Alignment
    
    var body: some View {
        VStack(spacing: 0) {
            color
                .frame(maxHeight: .infinity)
    
            LinearGradient(
                stops: [
                    Gradient.Stop(color: color, location: 0),
                    Gradient.Stop(color: .clear, location: 1)
                ],
                startPoint: alignment == .bottom ? .top : .bottom,
                endPoint: .center
            )
            .frame(height: height)
        }
    }
}


struct GradientMaskModifier: ViewModifier {
    
    var height: CGFloat
    var color: Color
    var alignment: Alignment
    
    func body(content: Content) -> some View {
        content
            .mask(alignment: alignment, { GradientMaskView(height: height, color: color, alignment: alignment) })
    }
}



