//
//  IconSelectionView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

enum DeviceAppIcon: Int, Identifiable, CaseIterable {
    
    case system = 0
    case space
    case sunset
    case indigo
    case gold
    case ocean
    case forest
    
    var title: String {
        switch self {
        case .system:
            return "System"
        case .space:
            return "Space"
        case .sunset:
            return "Sunset"
        case .forest:
            return "Forest"
        case .indigo:
            return "Indigo"
        case .gold:
            return "Gold"
        case .ocean:
            return "Ocean"
        }
    }
    
    var assetName: String {
        switch self {
        case .system:
            return "AppIcon"
        default:
            return "AppIcon\(self.id)"
        }
    }
    
    var id: Int {
        switch self {
        default:
            return self.rawValue
        }
    }
}

struct IconSelectionView: View {
    
    private let customIcons: [DeviceAppIcon] = [.system, .space, .sunset, .forest, .indigo, .gold, .ocean]
    @AppStorage("selectedIcon") private var selectedAppIcon: DeviceAppIcon = .system
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                MoreHeaderTextView(title: "Change app icon", subtitle: "Select one of the selections below.")
                Spacer()
                CloseButton()
            }
            .padding()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(self.customIcons, id: \.self) { icon in
                        Button {
                            self.updateIcon(to: icon)
                        } label: {
                            HStack {
                                Image(icon.title.lowercased())
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .scaledToFit()
                                    .clipShape(.rect(cornerRadius: 10))
                                
                                Text(icon.title)
                                    .foregroundStyle(.primary)
                                Spacer()
                                CheckboxView(isSelected: self.selectedAppIcon == icon)
                            }
                            .tag(icon)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 10))
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 50)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @MainActor
    func updateIcon(to icon: DeviceAppIcon) {
        self.selectedAppIcon = icon
        Task { @MainActor in
            guard UIApplication.shared.alternateIconName != icon.assetName else {
                /// No need to update since we're already using this icon.
                return
            }
            
            do {
                try await UIApplication.shared.setAlternateIconName(icon.assetName)
                dismiss()
            } catch {
                try await UIApplication.shared.setAlternateIconName(nil)
                dismiss()
            }
        }
    }
}


import SwiftUI

struct CheckboxView: View {
    
    let isSelected: Bool

    var body: some View {
        Image(systemName: self.isSelected ? "checkmark.square.fill" : "square.fill")
            .foregroundColor(self.isSelected ? .white : .black.opacity(0.5))
    }
}


import SwiftUI

struct MoreHeaderTextView: View {
    
    var title: String
    var subtitle: String?
    
    var body: some View {
        VStack {
            Text(self.title)
                .font(.headline)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .hSpacing(.leading)
            
            
            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .hSpacing(.leading)
            }
        }
    }
}
