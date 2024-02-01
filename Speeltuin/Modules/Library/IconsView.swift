//
//  IconsView.swift
//  Speeltuin
//
//  Created by alidinc on 23/01/2024.
//

import SwiftUI

struct IconsView: View {
    
    @Binding var icon: String
    @State private var query = ""
    @AppStorage("appTint") var appTint: Color = .blue
    @AppStorage("hapticsEnabled") var hapticsEnabled = true
    @State private var isExpanded = false
    
    var symbols: [String] {
        if self.query.isEmpty {
            SFModels.allSymbols
        } else {
            SFModels.allSymbols.filter({ $0.lowercased().contains(query.lowercased()) })
        }
    }
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack {
                SearchTextField(searchQuery: $query, prompt: "Search a symbol")
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 5), content: {
                        ForEach(symbols, id: \.self) { symbol in
                            Button {
                                setIcon(symbol: symbol)
                                
                                Task {
                                    do {
                                        try await Task.sleep(seconds: 0.05)
                                        
                                        isExpanded = false
                                        
                                    } catch {
                                        
                                    }
                                }
                                
                                if hapticsEnabled {
                                    HapticsManager.shared.vibrateForSelection()
                                }
                            } label: {
                                Icon(symbol: symbol)
                            }
                        }
                    })
                }
                .frame(height: 200)
            }
        } label: {
            DisclosureLabel
        }
        .padding(.horizontal)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
        .padding(.horizontal)
    }
    
    private func Icon(symbol: String) -> some View {
        Image(systemName: symbol)
            .padding()
            .imageScale(.medium)
            .overlay {
                if symbol == self.icon {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(appTint, lineWidth: 2)
                }
            }
    }
    
    private func setIcon(symbol: String) {
        if symbol == self.icon {
            self.icon = "bookmark"
        } else {
            self.icon = symbol
        }
    }
    
    private var DisclosureLabel: some View {
        HStack {
            Text("Selected icon")
                .font(.headline)
                .foregroundStyle(.gray)
            
            Spacer()
            
            if !icon.isEmpty {
                Image(systemName: icon)
                    .foregroundStyle(appTint)
                    .font(.headline)
                    .bold()
            } else {
                Image(systemName: "bookmark.fill")
                    .foregroundStyle(.primary.opacity(0.5))
                    .font(.headline)
                    .bold()
            }
        }
        .padding(.vertical, 12)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
