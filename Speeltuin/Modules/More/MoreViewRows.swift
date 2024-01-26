//
//  MoreViewRows.swift
//  Speeltuin
//
//  Created by alidinc on 26/01/2024.
//

import SwiftUI

extension MoreView {
    
    var SelectAppIconRow: some View {
        Button {
            self.showIcons.toggle()
        } label: {
            HStack {
                MoreRowView(imageName: "bolt.square.fill", text: " App icon")
                Spacer()
                Text(selectedAppIcon.title)
                    .foregroundStyle(.gray.opacity(0.5))
                    .font(.headline)
            }
        }
    }
    
    var ViewTypeRow: some View {
        Button {
            showStyleSelections = true
        } label: {
            HStack {
                MoreRowView(imageName: "rectangle.grid.1x2.fill", text: "View style")
                Spacer()
                
                Text(viewType.rawValue.capitalized)
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
                Toggle(isOn: $hapticsEnabled, label: {
                })
                .tint(.green)
            }
        }
    }
    
    var ColorSchemeRow: some View {
        Button(action: {
            showColorSchemeSelections = true
        }, label: {
            HStack {
                MoreRowView(imageName: "circle.lefthalf.filled", text: "Color scheme")
                Spacer()
                Text(scheme.title)
                    .foregroundStyle(.gray.opacity(0.5))
                    .font(.headline)
            }
        })
    }
    
}
