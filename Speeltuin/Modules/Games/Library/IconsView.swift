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
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem()], content: {
                        ForEach(symbols, id: \.self) { symbol in
                            Button(action: {
                                if symbol == icon {
                                    icon = "bookmark.fill"
                                } else {
                                    icon = symbol
                                    
                                    Task {
                                        do {
                                            try await Task.sleep(seconds: 0.05)
                                            
                                            withAnimation(.snappy) {
                                                isExpanded = false
                                            }
                                            
                                            if hapticsEnabled {
                                                HapticsManager.shared.vibrateForSelection()
                                            }
                                        } catch {
                                            
                                        }
                                    }
                                }
                            }, label: {
                                Image(systemName: symbol)
                                    .padding()
                                    .imageScale(.medium)
                                    .overlay {
                                        if symbol == icon {
                                            RoundedRectangle(cornerRadius: 10)
                                                .strokeBorder(appTint, lineWidth: 2)
                                        }
                                    }
                            })
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
