//
//  SearchTextField.swift
//  JustGames
//
//  Created by Ali Dinç on 31/12/2023.
//

import SwiftUI

struct SearchTextField: View {
    
    @Binding var searchQuery: String
    @Binding var prompt: String
    @AppStorage("appTint") var appTint: Color = .white
    
    var body: some View {
        HStack(spacing: 0) {
            TextField(prompt, text: $searchQuery)
                .frame(height: 24)
                .padding(10)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 8))
                .autocorrectionDisabled()
                .overlay(alignment: .trailing) {
                    HStack {
                        Spacer()
                        
                        if !searchQuery.isEmpty {
                            Button {
                                searchQuery = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        SFImage(name: "magnifyingglass", opacity: 0)
                    }
                }
        }
    }
}