//
//  SettingsView.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI



struct SettingsView: View {
    
    @AppStorage("appTint") var appTint: Color = .purple
    @AppStorage("selectedIcon") private var selectedAppIcon: DeviceAppIcon = .system
    @State private var showIcons = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    HStack {
                        MoreMainRowView(imageName: "paintpalette.fill", imageColor: .teal, text: "App Tint")
                        ColorPicker("", selection: $appTint, supportsOpacity: false)
                    }
                    
                    Button { self.showIcons.toggle() } label: {
                        HStack {
                            MoreMainRowView(imageName: "apps.iphone", imageColor: .teal, text: "App Icons")
                            Spacer()
                            Image(selectedAppIcon.title.lowercased())
                                .resizable()
                                .frame(width: 40, height: 40)
                                .scaledToFit()
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(.gray.opacity(0.15))
            .navigationTitle("Settings")
            .sheet(isPresented: $showIcons, content: {
                IconSelectionView()
                    .presentationDetents([.medium])
            })
        }
    }
}

#Preview {
    SettingsView()
}

import SwiftUI

struct MoreMainRowView: View {
    
    @State var imageName: String
    @State var imageColor: Color
    @State var text: String
    
    var body: some View {
        HStack {
            Image(systemName: self.imageName).foregroundColor(self.imageColor).imageScale(.large)
            Text(self.text).font(.headline.bold()).foregroundColor(.white)
            Spacer()
        }
        .contentShape(Rectangle())
        .frame(height: 40)
    }
}
