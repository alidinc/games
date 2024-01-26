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
                SearchTextField(searchQuery: $query, prompt: "Search a symbol")
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem()], content: {
                        ForEach(symbols, id: \.self) { symbol in
                            Button(action: {
                                if symbol == icon {
                                    icon = "bookmark.fill"
                                } else {
                                    icon = symbol
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
        .padding(.horizontal)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
        .padding(.horizontal)
    }
}
