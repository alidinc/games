//
//  View+Extensions.swift
//  A-games
//
//  Created by Ali Dinç on 17/12/2023.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    var safeArea: UIEdgeInsets {
        if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene) {
            return windowScene.keyWindow?.safeAreaInsets ?? .zero
        }
        
        return .zero
    }
    
    var currencySymbol: String {
        let locale = Locale.current
        return locale.currencySymbol ?? ""
    }
    
    func format(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func currencyString(_ value: Double, allowedDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = allowedDigits
        return formatter.string(from: .init(value: value)) ?? ""
    }
    
    func navigationLink<Destination: View>(_ destination: @escaping () -> Destination) -> some View {
        modifier(NavigationLinkModifier(destination: destination))
    }
    
    func backgroundBlur(radius: CGFloat = 3, opaque: Bool = false) -> some View {
        self.background(
            Blur(radius: radius, opaque: opaque)
        )
    }
    
    func innerShadow<S: Shape, SS: ShapeStyle>(
        shape: S,
        color: SS,
        lineWidth: CGFloat = 1,
        offsetX: CGFloat = 0,
        offsetY: CGFloat = 0,
        blur: CGFloat = 4,
        blendMode: BlendMode = .normal,
        opacity: Double = 1) -> some View {
            return self
                .overlay {
                    // MARK: - Bottom Sheet Inner Shadow (Border)
                    shape
                        .stroke(color, lineWidth: lineWidth)
                        .blendMode(blendMode)
                        .offset(x: offsetX, y: offsetY)
                        .blur(radius: blur)
                        .mask(shape)
                        .opacity(opacity)
                }
        }
    
    func gradientMask(height: CGFloat = 50, color: Color, alignment: Alignment = .bottom) -> some View {
        modifier(GradientMaskModifier(height: height, color: color, alignment: alignment))
    }
}

fileprivate struct NavigationLinkModifier<Destination: View>: ViewModifier {
    
    @ViewBuilder var destination: () -> Destination
    
    func body(content: Content) -> some View {
        content
            .background(
                NavigationLink(destination: self.destination) {
                    EmptyView()
                }.opacity(0)
            )
    }
}


extension View {
    @MainActor
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    
    func addToClipboardWithHaptics(with text: String) {
        UIPasteboard.general.setValue(text, forPasteboardType: "public.plain-text")
    }
}
