//
//  IconSelectionView.swift
//  Gametrack
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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                MoreHeaderTextView(title: "Change app icon", subtitle: "Select one of the selections below.")
                Spacer()
                CloseButton(.large)
            }
            
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
                                Text(icon.title)
                                    .foregroundStyle(.primary)
                                Spacer()
                                CheckboxView(isSelected: self.selectedAppIcon == icon)
                            }
                            .tag(icon)
                        }
                    }
                    .padding()
                    .background(.gray.opacity(0.15), in: .rect(cornerRadius: 20))
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.25))
        .edgesIgnoringSafeArea(.all)
    }
    
    func updateIcon(to icon: DeviceAppIcon) {
        self.selectedAppIcon = icon
        Task { @MainActor in
            guard UIApplication.shared.alternateIconName != icon.assetName else {
                /// No need to update since we're already using this icon.
                return
            }

            do {
                try await UIApplication.shared.setAlternateIconName(icon.assetName)
            } catch {
                try await UIApplication.shared.setAlternateIconName(nil)
            }
        }
        
        dismiss()
        HapticsManager.shared.vibrate(for: .warning)
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
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(self.title)
                .font(.system(.title3).bold())
                .foregroundColor(.primary)
            
            Text(self.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom)
        }
        .padding(.top)
    }
}
