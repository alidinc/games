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
    @Binding var isFocused: Bool
    @FocusState private var focused: Bool
    
    init(searchQuery: Binding<String>, prompt: String, isFocused: Binding<Bool> = .constant(false)) {
        self._searchQuery = searchQuery
        self._isFocused = isFocused
        self.prompt = prompt
    }
    
    var body: some View {
        HStack(spacing: 0) {
            TextField(prompt, text: $searchQuery)
                .frame(height: 30)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .font(.subheadline)
                .focused($focused)
                .labelStyle()
                .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 8))
                .autocorrectionDisabled()
                .onChange(of: isFocused, { oldValue, newValue in
                    focused = newValue
                })
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
