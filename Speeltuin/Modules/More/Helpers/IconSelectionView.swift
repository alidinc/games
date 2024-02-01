//
//  IconSelectionView.swift
//  Speeltuin
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

enum DeviceAppIcon: Int, Identifiable, CaseIterable {
    
    case teal = 0
    case space
    case sunset
    case indigo
    case gold
    case ocean
    case forest
    
    case orange
    case red
    case navy
    case purple
    case black
    case green
    
    var title: String {
        switch self {
        case .teal:
            return "Teal"
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
        case .orange:
            return "Orange"
        case .red:
            return "Red"
        case .navy:
            return "Navy"
        case .purple:
            return "Purple"
        case .black:
            return "Black"
        case .green:
            return "Green"
        }
    }
    
    var assetName: String {
        switch self {
        case .teal:
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
    
    private let dotIcons: [DeviceAppIcon] = [.teal, .space, .sunset, .forest, .indigo, .gold, .ocean]
    private let plusIcons: [DeviceAppIcon] = [ .black, .orange, .red, .navy, .purple, .green]
    
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @AppStorage("selectedIcon") private var selectedAppIcon: DeviceAppIcon = .black
    @AppStorage("appTint") var appTint: Color = .blue
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    MoreHeaderTextView(title: "Change app icon", subtitle: "Select one of the selections below.")
                    Spacer()
                    CloseButton()
                }
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack {
                        NavigationLink {
                            PlusIcons
                                .navigationTitle("Solid series")
                        } label: {
                            MoreRowView(imageName: "app", text: "Solid series")
                                .padding(16)
                                .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 10))
                                .shadow(radius: 1)
                        }
                        
                        NavigationLink {
                            DotIcons
                                .navigationTitle("Pastel series")
                        } label: {
                            MoreRowView(imageName: "app.dashed", text: "Pastel series")
                                .padding(16)
                                .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 10))
                                .shadow(radius: 1)
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private var PlusIcons: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(self.plusIcons, id: \.self) { icon in
                    Button {
                        self.updateIcon(to: icon)
                    } label: {
                        HStack {
                            Image(icon.title.lowercased())
                                .resizable()
                                .frame(width: 40, height: 40)
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 10))
                                .shadow(radius: 4)
                            
                            Text(icon.title)
                                .foregroundStyle(Color(uiColor: .label))
                                .font(.headline.bold())
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 10))
                        .shadow(radius: 1)
                        .overlay {
                            if selectedAppIcon == icon {
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(appTint, lineWidth: 2)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .scrollIndicators(.hidden)
    }
    
    private var DotIcons: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(self.dotIcons, id: \.self) { icon in
                    Button {
                        self.updateIcon(to: icon)
                    } label: {
                        HStack {
                            Image(icon.title.lowercased())
                                .resizable()
                                .frame(width: 40, height: 40)
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 10))
                                .shadow(radius: 4)
                            
                            Text(icon.title)
                                .foregroundStyle(Color(uiColor: .label))
                                .font(.headline.bold())
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.15), in: .rect(cornerRadius: 10))
                        .shadow(radius: 1)
                        .overlay {
                            if selectedAppIcon == icon {
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(appTint, lineWidth: 2)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .scrollIndicators(.hidden)
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
    
    @Environment(\.colorScheme) var colorScheme
    
    let isSelected: Bool

    var body: some View {
        Image(systemName: self.isSelected ? "checkmark.square.fill" : "square.fill")
            .foregroundColor(self.isSelected ? (colorScheme == .dark ? .white : .black) : .black.opacity(0.5))
    }
}
