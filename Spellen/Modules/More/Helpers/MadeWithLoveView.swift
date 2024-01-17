//
//  MadeWithLoveView.swift
//  JustGames
//
//  Created by Ali Dinç on 10/01/2023.
//

import SwiftUI

struct MadeWithLoveView: View {
    
    @State var textIndex = 0
    
    @AppStorage("selectedIcon") private var selectedAppIcon: DeviceAppIcon = .system
    
    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            Image(selectedAppIcon.title.lowercased())
                .resizable()
                .frame(width: 40, height: 40)
                .scaledToFit()
            
            Text("goodgames \(Bundle.main.appVersionLong)")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("iOS \(UIDevice.current.systemVersion)")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            HStack(alignment: .center, spacing: 2) {
                Text("Made with")   .foregroundStyle(.secondary)
                Image(systemName: "heart.fill").foregroundColor(.red)
            }
            .font(.system(size: 12))
            .hSpacing(.center)
        }
    }
}

