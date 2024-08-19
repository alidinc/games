//
//  IconSelectionView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

enum AppIcon: Int, Identifiable, CaseIterable {

    case black = 0
    case red
    case green
    case blue
    case purple
    case white
    case darkRed
    case darkGreen
    case darkBlue
    case darkIndigo

    var id: Self { return self }

    var assetName: String {
        switch self {
        case .black:
            return "Icon"
        default:
            return "Icon\(self.rawValue)"
        }
    }

    var iconName: String {
        switch self {
        case .black:
            return "AppIcon"
        default:
            return "AppIcon\(self.rawValue)"
        }
    }
}

struct IconSelectionView: View {

    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("selectedIcon") private var selectedAppIcon: AppIcon = .black
    @AppStorage("appTint") var appTint: Color = .blue
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    MoreHeaderTextView(title: "Change app icon", subtitle: "Select one of the selections below.")
                    Spacer()
                    CloseButton()
                }
                .padding(.bottom, 20)

                DotIcons
            }
            .padding()
        }
    }

    private var DotIcons: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
                ForEach(AppIcon.allCases) { icon in
                    Button {
                        self.updateIcon(to: icon)
                    } label: {
                        Image(icon.assetName)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 10))
                            .shadow(color: scheme == .dark ? .white.opacity(0.05) : .black.opacity(0.25), radius: 10)
                            .overlay {
                                if selectedAppIcon == icon {
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(appTint, lineWidth: 2)
                                }
                            }
                    }
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }


    func updateIcon(to icon: AppIcon) {
        self.selectedAppIcon = icon
       
        Task { @MainActor in
            guard UIApplication.shared.alternateIconName != icon.iconName else {
                /// No need to update since we're already using this icon.
                return
            }

            do {
                try await UIApplication.shared.setAlternateIconName(icon.iconName)
                print("Updating icon to \(String(describing: icon.iconName)) succeeded.")
            } catch {
                print("Updating icon to \(String(describing: icon.iconName)) failed.")
                try await UIApplication.shared.setAlternateIconName(nil)
            }
        }
    }
}


import SwiftUI

struct CheckboxView: View {

    @Environment(\.colorScheme) var colorScheme

    let isSelected: Bool

    var body: some View {
        Image(systemName: self.isSelected ? "checkmark.square.fill" : "square.fill")
            .foregroundColor(self.isSelected ? (colorScheme == .dark ? .white : .black) : .black.opacity(0.5))
    }
}
