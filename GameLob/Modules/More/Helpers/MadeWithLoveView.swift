//
//  MadeWithLoveView.swift
//  JustGames
//
//  Created by Ali Dinç on 10/01/2023.
//

import SwiftUI

struct MadeWithLoveView: View {
    
    private var values = ["🇹🇷", "🇬🇧", "🇳🇱"]
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
                Spacer()
                HStack(alignment: .center, spacing: 2) {
                    Text("Made with")   .foregroundStyle(.secondary)
                    Image(systemName: "heart.fill").foregroundColor(.red)
                    Text("from ")  .foregroundStyle(.secondary)
                }.font(.system(size: 12))
                
                Text(self.values[self.textIndex])
                    .font(.system(size: 22))
                    .onReceive(Timer.publish(every: 2, on: .main, in: .common).autoconnect(), perform: { _ in
                        self.next()
                    })
                
                Spacer()
            }
        }
    }
    
    private func next() {
        var next = self.textIndex + 1
        if next == self.values.count {
            next = 0
        }
        withAnimation {
            self.textIndex = next
        }
    }
}

