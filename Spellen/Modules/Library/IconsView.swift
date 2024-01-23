//
//  IconsView.swift
//  Spellen
//
//  Created by alidinc on 23/01/2024.
//

import SwiftUI

struct IconsView: View {
    
    @Binding var icon: String
    
    @State private var query = ""
    @AppStorage("appTint") var appTint: Color = .white
    
    var symbols: [String] {
        if self.query.isEmpty {
            SFModels.allSymbols
        } else {
            SFModels.allSymbols.filter({ $0.lowercased().contains(query.lowercased()) })
        }
    }
    
    var body: some View {
        DisclosureGroup {
            VStack {
                SearchTextField(searchQuery: $query, prompt: .constant("Search a symbol"))
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem()], content: {
                        ForEach(symbols, id: \.self) { symbol in
                            Button(action: {
                                icon = symbol
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
                .frame(height: 175)
            }
        } label: {
            HStack {
                Text("Selected icon")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if !icon.isEmpty {
                    SFImage(name: icon)
                } else {
                    SFImage(name: "star")
                }
            }
            .padding(.vertical, 4)
        }
        .padding(.horizontal)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
        .padding(.horizontal)
    }
}