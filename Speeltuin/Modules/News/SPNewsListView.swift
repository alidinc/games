//
//  SPNewsListView.swift
//  Speeltuin
//
//  Created by alidinc on 29/01/2024.
//

import SwiftData
import SwiftUI

struct SPNewsListView: View {
    
    var item: SPNews
    let dataManager: DataManager
    
    @Query(animation: .easeInOut) private var savedNews: [SPNews]
    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(item.title)
                .foregroundStyle(.primary)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
            
            HStack(alignment: .bottom) {
                if let description = item.details {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .lineLimit(6, reservesSpace: true)
                }
                
                Spacer()
                
                Button {
                    if self.savedNews.compactMap({$0.persistentModelID}).contains(item.persistentModelID) {
                        showAlert = true
                    }
                } label: {
                    SFImage(name: "bookmark.fill")
                }
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.size.width - 20)
        .background(colorScheme == .dark ? .ultraThinMaterial : .ultraThick, in: .rect(cornerRadius: 20))
        .shadow(radius: colorScheme == .dark ? 4 : 2)
        .alert("It's already saved!", isPresented: $showAlert) {
            Button(role: .destructive) {
                if let newsToDelete = savedNews.first(where: {$0.title == item.title }) {
                    modelContext.delete(newsToDelete)
                }
                
                if hapticsEnabled {
                    HapticsManager.shared.vibrateForSelection()
                }
            } label: {
                Text("Delete")
            }

            Button(role: .cancel) {
                
            } label: {
                Label("Cancel", systemImage: "checkmark")
            }
        } message: {
            Text("Would you like to delete it?")
        }
    }
}
