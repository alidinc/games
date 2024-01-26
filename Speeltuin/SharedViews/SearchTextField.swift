//
//  SearchTextField.swift
//  Speeltuin
//
//  Created by Ali Dinç on 31/12/2023.
//

import SwiftUI

struct SearchTextField: View {
    
    @Binding var searchQuery: String
    var prompt: String
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            TextField(prompt, text: $searchQuery)
                .frame(height: 30)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .font(.subheadline)
                .background(colorScheme == .dark ? .quaternary : .tertiary, in: .rect(cornerRadius: 8))
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
                        
                        Image(systemName: "magnifyingglass")
                            .imageScale(.medium)
                            .font(.headline)
                            .padding(.trailing, 8)
                            .foregroundStyle(.primary)
                    }
                }
        }
    }
}
