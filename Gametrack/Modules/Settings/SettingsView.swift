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
            VStack {
                Header
                
                Form {
                    Section("Appearance") {
                        HStack {
                            MoreMainRowView(imageName: "paintpalette.fill", imageColor: .teal, text: "App Tint")
                            ColorPicker("", selection: $appTint, supportsOpacity: false)
                        }
                        
                        Button {
                            DispatchQueue.main.async {
                                self.showIcons.toggle()
                            }
                        } label: {
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
            }
            
            .scrollContentBackground(.hidden)
            .background(.gray.opacity(0.15))
            .sheet(isPresented: $showIcons, content: {
                IconSelectionView()
                    .presentationDetents([.medium])
            })
        }
    }
    
    private var Header: some View {
        Text("Settings")
            .font(.system(size: 26, weight: .semibold))
            .foregroundStyle(.primary)
            .shadow(radius: 10)
            .hSpacing(.leading)
            .padding(.horizontal)
            .padding(.vertical, 10)
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
