//
//  MoreViewRows.swift
//  Speeltuin
//
//  Created by alidinc on 26/01/2024.
//

import SwiftUI

extension MoreTab {
    
    var SelectAppIconRow: some View {
        DisclosureGroup(isExpanded: $iconSelected) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 5)) {
                ForEach(AppIcon.allCases) { selection in
                    Button {
                        self.updateIcon(to: selection)
                    } label: {
                        Image("\(selection.assetName)")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(.rect(cornerRadius: 12))
                            .shadow(color: scheme == .dark ? .white.opacity(0.05) : .black.opacity(0.25), radius: 10)
                    }
                    .tag(selection.id)
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 12)
        } label: {
            HStack {
                MoreRowView(imageName: "bolt.square.fill", text: " App Icon")
                Spacer()
                Image(selectedAppIcon.assetName)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(.rect(cornerRadius: 10))
                    .shadow(color: scheme == .dark ? .white.opacity(0.05) : .black.opacity(0.25), radius: 10)
            }
        }
        .tint(.secondary)
    }

    func updateIcon(to icon: AppIcon) {
        self.selectedAppIcon = icon

        withAnimation {
            self.iconSelected = false
        }

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

    var ViewTypeRow: some View {
        Menu {
            ForEach(ViewType.allCases) { type in
                Button(type.rawValue.capitalized, systemImage: type.imageName) {
                    self.viewType = type
                }
            }
        } label: {
            HStack {
                MoreRowView(imageName: "rectangle.grid.1x2.fill", text: "View Style")
                Spacer()

                Text(viewType.rawValue.capitalized)
                    .foregroundStyle(.gray.opacity(0.5))
                    .font(.headline)

                Image(systemName: viewType.imageName)
                    .foregroundStyle(.gray.opacity(0.5))
                    .font(.headline)
            }
        }
    }
    
    var HapticsRow: some View {
        Button {
            hapticsEnabled.toggle()
            if hapticsEnabled {
                HapticsManager.shared.vibrate(type: .success)
            }
        } label: {
            HStack {
                MoreRowView(imageName: "hand.tap.fill", text: "Haptics")
                Spacer()
                Toggle(isOn: $hapticsEnabled, label: {})
                    .tint(.green)
            }
        }
    }
    
    var ColorSchemeRow: some View {
        Menu {
            ForEach(SchemeType.allCases) { type in
                Button(type.title, systemImage: type.imageName) {
                    scheme = type
                }
            }
        } label: {
            HStack {
                MoreRowView(imageName: "moon.fill", text: "Color Scheme")
                Spacer()
                Text(scheme.title)
                    .foregroundStyle(.gray.opacity(0.5))
                    .font(.headline)
            }
        }
    }
}
