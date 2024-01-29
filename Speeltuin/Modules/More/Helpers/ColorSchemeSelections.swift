//
//  ColorSchemeSelections.swift
//  Speeltuin
//
//  Created by alidinc on 25/01/2024.
//

import SwiftUI

enum SchemeType: Int, Identifiable, CaseIterable {
    var id: Self { self }
    case system
    case light
    case dark
    
    
    var title: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
    
    var imageName: String {
        switch self {
        case .system:
            return "moon.fill"
        case .light:
            return "circle.lefthalf.filled.righthalf.striped.horizontal"
        case .dark:
            return "circle.lefthalf.filled.righthalf.striped.horizontal.inverse"
        }
    }
}


struct ColorSchemeSelections: View {

    @AppStorage("colorScheme") private var scheme: SchemeType = .system
    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                MoreHeaderTextView(title: "Color scheme", subtitle: "This will affect the system color scheme.")
                Spacer()
                CloseButton { self.dismiss() }
            }
            .padding(.bottom, 20)
            
            ScrollView {
                VStack {
                    ForEach(SchemeType.allCases, id: \.id) { type in
                        Button {
                            scheme = type
                            dismiss()
                        } label: {
                            MoreRowView(imageName: type.imageName, text: type.title)
                                .padding(16)
                                .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 10))
                                .shadow(radius: 1)
                                .overlay {
                                    if scheme == type {
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(appTint, lineWidth: 2)
                                    }
                                }
                        }
                    }
                }
            }
        }
        .padding()
    }
}
