//
//  CloseButton.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct CloseButton: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var type: ButtonType = .medium
    var onDismiss: (() -> Void)?
    
    enum ButtonType {
        case large
        case medium
        case small
        
        var size: Font {
            switch self {
            case .large:
                return .title
            case .medium:
                return .title2
            case .small:
                return .title3
            }
        }
    }
    
    init(_ type: ButtonType, onDismiss: ( () -> Void)? = nil) {
        self.type = type
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        Button {
            dismiss()
            
            if let onDismiss {
                onDismiss()
            }
        } label: {
            Image(systemName: "xmark.circle.fill")
        }
        .font(type.size)
        .padding()
    }
}
