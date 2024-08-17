//
//  GlassModifier.swift
//  Games
//
//  Created by Ali Dinç on 17/08/2024.
//

import SwiftUI

extension View {
    func glass(radius: CGFloat = 12, with color: Color = .white) -> some View {
        modifier(GlassBackgroundModifier(radius: radius, color: color))
    }
}

struct GlassBackgroundModifier: ViewModifier {

    let radius: CGFloat
    let color: Color

    @Environment(\.colorScheme) var scheme

    func body(content: Content) -> some View {
        content
            .background(content: {
                TransparentBlurView(removeAllFilters: true)
                    .blur(radius: 9, opaque: true)
                    .background((scheme == .dark ? Color.white : Color.black).opacity(0.05))
                    .clipShape(.rect(cornerRadius: radius))
            })
            .clipShape(.rect(cornerRadius: radius, style: .continuous))
            /// Light White Border
            .background {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke((scheme == .dark ? Color.white.opacity(0.3) : Color.black.opacity(0.2)), lineWidth: 1.5)
            }
    }
}


struct TransparentBlurView: UIViewRepresentable {
    var removeAllFilters: Bool = false
    func makeUIView(context: Context) -> TransparentBlurViewHelper {
        return TransparentBlurViewHelper(removeAllFilters: removeAllFilters)
    }

    func updateUIView(_ uiView: TransparentBlurViewHelper, context: Context) {

    }
}

/// Disabling Trait Changes for Our Transparent Blur View
class TransparentBlurViewHelper: UIVisualEffectView {
    init(removeAllFilters: Bool) {
        super.init(effect: UIBlurEffect(style: .systemUltraThinMaterial))

        /// Removing Background View, if it's Available
        if subviews.indices.contains(1) {
            subviews[1].alpha = 0
        }

        if let backdropLayer = layer.sublayers?.first {
            if removeAllFilters {
                backdropLayer.filters = []
            } else {
                /// Removing All Expect Blur Filter
                backdropLayer.filters?.removeAll(where: { filter in
                    String(describing: filter) != "gaussianBlur"
                })
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Disabling Trait Changes
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

    }
}
